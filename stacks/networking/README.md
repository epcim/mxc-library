# Networking Service Stack

This directory contains advanced tunnel mesh networks and multi-cluster routing planes.

## 📦 Stack Components

* **`netbird.cue`**: Private wireguard-based zero-trust overlay network securely linking nodes, edges, and VMs across any firewall.
* **`traefik.cue`**: Specialized Traefik middlewares (including Authelia SSO forwarding overlays and rate limiting).
* **`policies.cue`**: Parameterized generator for standard, high-fidelity Kubernetes NetworkPolicies to manage isolation, local access, DNS, and internet egress.

---

## 🛡️ Shared Network Policies (`policies.cue`)

The `policies.cue` file provides a **parameterized schema `#NamespacePolicies`** that generates standardized, secure network isolation and egress control rules for any Kubernetes namespace:

* **`denyAll`**: Default Deny-All policy for both Ingress and Egress traffic.
* **`allowLocal`**: Allows pods within the same namespace to communicate with each other.
* **`allowIngress`**: Restricts incoming ingress traffic to the Traefik edge (defaults to the `zone-service` namespace).
* **`allowDNS`**: Restricts DNS resolution (UDP/TCP port 53) strictly to the `kube-system` namespace.
* **`allowInternet`**: Enables public internet access while **explicitly blocking all local private RFC1918 subnets** (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`).

### 🛠️ Instantiating Policies in Your Stack

To enforce these policies in any app stack (e.g. `media`, `cicd`, or custom namespaces):

```cue
package my_stack

import (
	"github.com/epcim/mxc-library/stacks/networking"
)

#MyPolicies: networking.#NamespacePolicies & {
	#Namespace: "my-namespace"
}
```

---

## 🛠️ Usage & Configuration

```cue
# Example cluster-home-mxc integration
package apps

import "github.com/epcim/mxc-library/stacks/networking"

apps: {
    netbird: networking.#NetBird & {
        // Zero-trust node connectors
    }
}
```
