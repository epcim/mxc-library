# Infrastructure Service Stack

This directory contains core cluster-level ingress controllers, bare-metal load balancers, smart home platforms, and comprehensive telemetry/monitoring suites.

> [!NOTE]
> For core maintenance rules, directory roles, CUE design principles, and local validation workflows, please refer to the [MXC Workload Library Architectural Guide](../README.md).

---

## 📦 Stack Components

* [**Traefik Ingress Route Controller**](#-traefik-ingress-route-controller)
* [**Authelia Single Sign-On**](#-authelia-single-sign-on)
* [**MetalLB Bare-Metal Load Balancer**](#-metallb-bare-metal-load-balancer)
* [**Monitoring Suite**](#-monitoring-suite)
* [**Home Assistant (Hass)**](#-home-assistant)
* [**iPXE Boot Fileserver (Caddy)**](#-ipxe-boot-fileserver-caddy)

---

## 🚦 Traefik Ingress Route Controller

Traefik is our primary reverse proxy and router, binding on ports `80` (web) and `443` (websecure), managing SSL certificates, and integrating forward authorization middleware.

---

## 🔐 Authelia Single Sign-On

Authelia serves as our central SSO provider and OIDC identity manager, running under the `sys` namespace.

### 1. Generating Base Secrets
Run the following tools to generate raw keys for `vars-sec.yml` encryption:
```fish
# JWT, Session, and Storage Encryption Keys
openssl rand -hex 32

# OIDC RSA Private Key
openssl genrsa 4096
```

### 2. Password & Client Hashing
To generate secure Argon2/PBKDF2 hashes for user database access:
```bash
# User Password Hash (Argon2)
docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'YourSecurePassword'

# NetBird Client Secret Hash (PBKDF2)
docker run --rm authelia/authelia:latest authelia crypto hash generate pbkdf2 --password 'YourClientSecret'
```

### 3. Quick Troubleshooting
To reset a user's 2FA configurations inside the SQLite backend directly:
```bash
kubectl exec -n sys deployment/authelia -- sqlite3 /data/db.sqlite3 "DELETE FROM totp_configurations WHERE username='admin';"
```

---

## 🛡️ Monitoring Suite (Grafana, Alloy, Loki, Mimir)

The monitoring stack is optimized to run efficiently inside single-node environments like MicroK8s:

### 1. Loki Log Storage Mode
To run logs storage efficiently without a massive distributed cluster, Loki is forced into **SingleBinary** deployment mode:
```yaml
loki:
  deploymentMode: SingleBinary
```

### 2. Mimir Metrics Compaction
Mimir is configured for single-replica execution by setting the ingester ring replication factor to `1` to avoid consensus errors:
```yaml
mimir:
  ingester:
    ring:
      replication_factor: 1
```

### 3. Grafana Administrator Password Reset
To reset your Grafana admin password from the command line:
```bash
kubectl exec -ti -n mon deploy/grafana -- bash
grafana-cli --homepath "/usr/share/grafana" admin reset-admin-password 'NEW_SECURE_PASSWORD'
```

---

## 🔌 iPXE Boot Fileserver (Caddy)

Our persistent, in-cluster iPXE fileserver is deployed via `mxc-library/stacks/infra/ipxe-boot.cue` to allow new bare-metal or Proxmox machines to boot dynamically without a physical USB drive.

### 1. Caddy Configuration
It utilizes a lightweight Caddy container with custom header injection. This forces `.ipxe` boot scripts to return `text/plain` MIME types so that the motherboard BIOS parses them with 100% stability.

### 2. IPAM and Routing
* Exposes Port `80` with a dedicated LoadBalancer IP: `172.31.2.52` under the `servers` address pool on VLAN20.
* Integrates with UniFi Controller Network boot settings.

---

## 🎨 Best-Practice CUE Modeling Patterns

When working on infrastructure-level stacks (like reverse proxies, SSOs, and fileservers), apply the following patterns:

### 1. Leverage Sizing Presets (Flavors)
Always define resource limits and requests inside a private `_flavor` map inside your stack schema, keyed by `flavor` string. This allows environment configurations to scale resources instantly (e.g. from `small` to `medium` or `large`) without repeating resource blocks. Refer to `stacks/infra/traefik.cue` or `stacks/infra/velero.cue` for production examples.

### 2. Isolate Application-Specific Overlays
Do not pollute base templates with app-specific logic. Put helper overlays (such as Traefik IngressRoutes or Authelia configuration maps) inside `adapters/kluctl/overlays/authelia/` or `adapters/kluctl/overlays/traefik/`. Refer to `kustomize.resources` in `traefik.cue` to see how static assets are cleanly composed.

### 3. De-couple Ingress Namespaces
Never hardcode `namespace` inside Ingress, IngressRoute, or Secret overlays. Set the namespace dynamically via `kustomize.namespace` inside the stack. Kluctl and Kustomize will inject the namespace globally on all rendered outputs.

