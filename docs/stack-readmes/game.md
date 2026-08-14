# Game Service Stack

This directory contains standalone, lightweight game servers and containerized classic web workloads.

## 📦 Stack Components

* **`pacman.cue`**: HTML5 remake of the retro Pacman arcade classic.
* **`tetris.cue`**: Dynamic, containerized Tetris block-puzzle game.
* **`game2048.cue`**: The classic sliding tile addition game.
* **`k8s-networkpolicy.cue`**: Hardened isolation policies to sandbox standalone game instances inside your cluster.

---

## 🛠️ Usage & Configuration

To deploy games to your cluster, declare them in your environment's `apps` list:

```cue
# Example cluster-home-mxc integration
package apps

import "github.com/epcim/mxc-library/stacks/game"

apps: {
    pacman: game.#Pacman & {
        expose: http: target: "ingress"
    }
    tetris: game.#Tetris & {
        expose: http: target: "ingress"
    }
}
```

---

## 🛡️ Sandbox Network Policies

By default, games are deployed in a fully isolated sandbox to prevent low-trust game containers from reaching internal databases, server management planes, or home local networks.

This is enforced via **reusable policies instantiations** inside `k8s-networkpolicy.cue` (which inherits from the shared `#NamespacePolicies` schema).

### ⚙️ Enabling/Disabling Egress in `apps-games.cue`

To toggle DNS or public internet access for your games, configure the `cluster: networkPolicies` block in your active target (e.g. `cluster-home-mxc/apps-games.cue`):

```cue
cluster: networkPolicies: {
    // 🔒 Core Sandbox (Enabled by default):
    "game-default-deny":       game.#GamePolicies.denyAll
    "game-allow-local":        game.#GamePolicies.allowLocal
    "game-allow-ingress":      game.#GamePolicies.allowIngress

    // 🔓 Uncomment to enable DNS resolution:
    // "game-allow-dns":          game.#GamePolicies.allowDNS

    // 🔓 Uncomment to enable public internet egress (while keeping RFC1918 local IPs blocked!):
    // "game-allow-internet":     game.#GamePolicies.allowInternet
}
```

To apply any changes to your network policies:
1. Export the variables: `just mxc::export cluster-home-mxc`
2. Deploy the game stack: `just mxc::apply cluster-home-mxc --include-tag game --yes`
