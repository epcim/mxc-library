# Game Service Stack

This directory contains standalone, lightweight classic arcade web workloads and containerized game servers.

> [!NOTE]
> For core maintenance rules, directory roles, CUE design principles, and local validation workflows, please refer to the [MXC Workload Library Architectural Guide](../README.md).

---

## 📦 Stack Components

* **`pacman.cue`**: Containerized classic retro HTML5 Pacman.
* **`tetris.cue`**: Containerized retro Tetris block puzzle.
* **`game2048.cue`**: Sliding tile 2048 addition puzzle.

---

## 🛠️ Sizing & Resource Customization

To deploy games inside your cluster, add them to your `apps.cue` sheet:

```cue
package apps

import "github.com/epcim/mxc-library/stacks/game"

apps: {
    pacman: game.#Pacman & {
        expose: http: target: "ingress"
    }
}
```

---

## 🔒 Security Sandboxing & Isolation

Because retro arcade games are web-facing, we enforce network sandboxing. The **`k8s-networkpolicy.cue`** helper automatically restricts outbound and ingress traffic for these pods, ensuring game containers cannot access sensitive cluster-internal database planes or management components.

---

## 🎨 Best-Practice CUE Modeling Patterns

When building or adding lightweight workloads like games, apply these core guidelines:

### 1. Enforce Out-of-the-Box Sandboxing
When creating games, always apply the `game` namespace and ensure they trigger the automated network policy. By bundling default network constraints with the stack definition, we prevent insecure default deployments.

### 2. Keep Workloads Flat & Simple (Rule 5)
Do not use subdirectories or auxiliary resource overrides for simple single-container game workloads. Keep them as flat `.cue` files inside `stacks/game/` to eliminate boilerplate and ensure the repository stays perfectly clean.

