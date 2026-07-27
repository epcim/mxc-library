# Networking Service Stack

This directory contains advanced zero-trust peer-to-peer overlay tunnels and domain ingress route wrappers.

---

## 📦 Stack Components

* **`netbird.cue`**: Declarative zero-trust overlay connection network utilizing WireGuard.
* **`traefik.cue`**: Middleware hooks, TLS definitions, and Authelia SSO routes.

---

## 🔒 NetBird Peer Configuration

To join a private mesh tunnel network, the NetBird client is configured with specific setup keys managed via schema-driven variables. 

```cue
package apps

import "github.com/epcim/mxc-library/stacks/networking"

apps: {
    netbird_client: networking.#NetBird & {
        // Wireguard network configuration
    }
}
```

The container automatically mounts the private setup keys from secret generators, boots securely, registers itself as an active router gateway, and isolates your node network behind custom, secure firewalls.
