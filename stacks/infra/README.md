# Infrastructure Service Stack

This directory contains core cluster-level operators, platform controllers, and smart-home platforms.

## 📦 Stack Components

* **`traefik.cue`**: Standard Reverse Proxy and Ingress Controller handling routing, TLS handshakes, and SSO gateways.
* **`metallb.cue`**: Software load-balancer provisioning physical load-balancer VIPs for bare-metal Kubernetes.
* **`monitoring.cue`**: Fully unified Grafana, Alloy (collector), Loki (logs), and Mimir (metrics) telemetry stack.
* **`hass.cue`**: Home Assistant platform managing local IoT devices and home automation networks.
* **`kluctl.cue`**: Native bootstrap configuration managing Kluctl git-ops controller reconciliations.
* **`velero.cue`**: Disaster recovery and cluster migration operator managing stateful volume backups and snapshotting.

---

## 🛠️ Usage & Configuration

```cue
# Example cluster-home-mxc integration
package apps

import "github.com/epcim/mxc-library/stacks/infra"

apps: {
    traefik: infra.#Traefik & {
        // Core ingress controllers
    }
    monitoring: infra.#Monitoring & {
        // Alloy collectors + Grafana telemetry visualization
    }
    velero: infra.#Velero & {
        context: {
            credentials: {
                secretContents: {
                    cloud: """
                        [default]
                        aws_access_key_id={{ secrets.velero.accessKey }}
                        aws_secret_access_key={{ secrets.velero.secretKey }}
                        """
                }
            }
            configuration: {
                backupStorageLocation: [
                    {
                        name: "minio"
                        provider: "aws"
                        bucket: "velero"
                        default: true
                        config: {
                            region: "minio"
                            s3ForcePathStyle: "true"
                            s3Url: "{{ secrets.velero.s3Url }}"
                        }
                    }
                ]
            }
        }
    }
}
```

---

## 🌐 iPXE Boot Service (`#IPXEBoot`)

The `#IPXEBoot` component deploys a high-performance **Caddy-backed** web server specifically optimized to orchestrate bare-metal network boots, automated Talos Linux installations, and interactive provisioning.

### 🌟 Key Features
* **MetalLB Direct LoadBalancer VIP Support:** Exposes Caddy natively on a dedicated external IP over standard Port 80, fully bypassing reverse proxies to ensure seamless compatibility with restricted physical motherboard NIC/PXE BIOS drivers.
* **Smart Architecture Normalization:** Embeds custom logic to detect and transparently translate Legacy BIOS environments (setting standard iPXE `${arch}` to `i386` or returning empty) directly to standard 64-bit AMD64 (`kernel-amd64` / `initramfs-amd64.xz`).
* **Interactive Dynamic Provisioning:** Serves custom MAC-specific auto-install scripts (`profiles/525400123456.ipxe`) and falls back to an elegant menu with Sidero Image Factory downloading or public `netboot.xyz` chainloading.

---

### 🔧 Configuration Example

```cue
package apps

import "github.com/epcim/mxc-library/stacks/infra"

apps: {
    "ipxe-boot": infra.#IPXEBoot & {
        kustomize: {
            resources: [
                "helm-rendered.yaml",
                "overlays/ipxe-boot/configmap.yml",  // Inject Caddyfile and boot.ipxe
                "overlays/pvc.yaml",                 // Enable persistent storage
            ]
        }
        overlays: {
            pvc: [{
                name:         "ipxe-boot-assets"     // PVC to store kernel & initramfs binaries
                size:         "2Gi"
                storageClass: "longhorn"
            }]
        }
        context: {
            service: main: {
                annotations: {
                    "metallb.io/address-pool": "service-pool"
                }
                loadBalancerIP: "172.31.30.52"       // Dedicated Port 80 boot IP
            }
            ingress: main: {
                enabled:   true
                className: "zone-service-traefik"    // Internal routing for administrative views
                hosts: [{
                    host: "boot.svc.yourdomain.com"
                    paths: [{
                        path:     "/"
                        pathType: "Prefix"
                        service: {
                            identifier: "main"
                            port:       "http"
                        }
                    }]
                }]
            }
            persistence: assets: {
                enabled:       true
                existingClaim: "ipxe-boot-assets"    // Mount PVC under /usr/share/caddy/assets
            }
        }
    }
}
```

---

### 📂 File Structure Inside Caddy Webroot

The Caddy server maps files inside `/usr/share/caddy/` and serves them statically:

| Webroot Path | ConfigMap Source Key | Description |
|--------------|----------------------|-------------|
| `/etc/caddy/Caddyfile` | `Caddyfile` | Serves webroot on `:80` with plain-text MIME overrides for `.ipxe` files |
| `/usr/share/caddy/boot.ipxe` | `boot.ipxe` | Central entrypoint loaded by DHCP Option 67 |
| `/usr/share/caddy/profiles/default.ipxe` | `default-profile.ipxe` | Default fallback variables profile |
| `/usr/share/caddy/profiles/<mac-hex>.ipxe` | N/A | Optional MAC-specific auto-install profile files |
| `/usr/share/caddy/assets/talos/<version>/` | N/A | Stores downloaded Talos kernel (`kernel-amd64`) and initramfs files |

