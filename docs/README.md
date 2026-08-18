# 🏛️ MXC Workload Library Documentation

Welcome to the **Model-X Configuration (MXC) Library** developer and architecture documentation. This library houses standard, production-ready, and highly-customizable workload compositions ("The Content") decoupled from the central CUE compilation engine ("The Engine") and physical renderers ("The Adapters").

This directory acts as the central reference hub for platform engineers, community contributors, and agentic developers extending the library.

---

## 🗺️ Documentation Map

To help you navigate the system, our per-application architecture and deployment guides are structured into domain-specific stacks:

| Domain | Scope & Description | Key Stack Components | Guides |
| :--- | :--- | :--- | :--- |
| **⚙️ Infrastructure** | Ingress, authentication, bare-metal load balancing, IPAM, and monitoring. | Traefik, Authelia, MetalLB, iPXE-Boot, Prometheus/Grafana | [Infrastructure Guide](infra/README.md) |
| **🛡️ CI/CD** | Automated delivery pipelines, secure container registries, and dependency updating. | Harbor, Woodpecker CI, Renovate Bot | [CI/CD Guide](cicd/README.md) |
| **🛜 Networking** | Zero-trust overlay mesh tunnels, virtual private gateways, and routing overlays. | NetBird client, Traefik middlewares | [Networking Guide](networking/README.md) |
| **💾 Storage** | Highly available distributed block-storage engines and volume orchestrators. | Longhorn | [Storage Guide](storage/README.md) |
| **🎬 Media** | Containerized entertainment systems and local object storage caches. | Emby, Silo | [Media Guide](media/README.md) |
| **🎮 Game** | Isolated, sandboxed retro arcade games and game-server workloads. | Pacman, Tetris, Game-2048, NetworkPolicies | [Game Guide](game/README.md) |

---

## 🏛️ Directory Architecture & Roles

```text
mxc-library/
├── cue.mod/                   # CUE Module metadata
│   └── module.cue             # Declares module name: "github.com/epcim/mxc-library"
├── bases/                      # Core system bootstrapping (Namespaces, MetalLB resources)
├── stacks/                     # CUE workload declarations (Logical Intent - "The Content")
│   ├── cicd/                  # Woodpecker, Renovate, Harbor
│   ├── game/                  # Game namespaces and isolated workloads
│   ├── infra/                 # Core utilities (MetalLB, Traefik, Grafana, Loki)
│   ├── media/                 # Storage-heavy media stacks (Emby, Silo)
│   └── networking/            # NetBird client gateways, DNS stacks
└── adapters/                  # Rendering Adapters (Physical Bindings - "The Engine")
    └── kluctl/                # Kluctl-specific render adapters
        ├── helm-chart.yml     # Standard Helm chart fetch specification
        ├── helm-values.yml    # Parameter-to-values binding
        ├── kustomization.yml  # Kustomize list of resources
        ├── overlays/          # PVCs, NetworkPolicies, custom ConfigMaps
        └── vars.yml           # Base bindings and default values
```

---

## 🛡️ Core Rules for Library Maintenance

To maintain portability, prevent code drift, and keep our GitOps configurations extremely lean, all contributors (including human developers and AI agents) must strictly adhere to the following rules:

### Rule 1: No Duplicate Active Code Logic
To avoid code drift, all active logical projections and type schemas **must belong strictly to the base `mxc` repository**. Any logical `projection.cue` file inside the `mxc-library` directory must act as a **pass-through delegation alias** importing and inheriting dynamically from the `github.com/epcim/mxc/...` namespace.

*   **Example (`adapters/kluctl/projection.cue`):**
    ```cue
    package kluctl

    import (
        base "github.com/epcim/mxc/adapters/kluctl:kluctl"
    )

    #FromCluster: base.#FromCluster
    ```

### Rule 2: Standalone OCI Portability for Templates
Static `.yml` or `.yaml` template files (such as `helm-chart.yml`, `kustomization.yml`, etc.) must exist as physical copies in both repositories.
> [!IMPORTANT]
> **Never use OS-level symbolic links or relative parent path traversals (`../`)** for static template assets inside the library adapters. This ensures the library can be packaged and extracted as an independent, standalone OCI container in production without broken dependencies.

### Rule 3: Application-Specific Overlays Location
*   **Completely generic overlays** (such as base PersistentVolumeClaims, standard rollout cronjobs, or base NetworkPolicies) belong inside `mxc/adapters/kluctl/overlays/`.
*   **Application-specific overlays** (such as specialized configmaps, ingress overrides, or secret generation for Authelia, NetBird, or Traefik) belong strictly inside `mxc-library/adapters/kluctl/overlays/`.

### Rule 4: Centralization of Common Stack Defaults
Standard platform configurations, deployment tags, ports, sizing presets, resources, and credentials schemas must be declared as native defaults directly inside the stack CUE files (e.g., `mxc-library/stacks/infra/velero.cue`).
*   This keeps cluster-level environment CUE files perfectly lean and minimal (e.g., `velero: stk_infra.#Velero` without redundant duplicate blocks).
*   **Example Sizing Preset (Flavors):**
    ```cue
    #MyWorkload: S=schema.#App & {
        _flavor: {
            small: {
                context: resources: {
                    limits: { memory: "256Mi" }
                    requests: { cpu: "10m", memory: "64Mi" }
                }
            }
            medium: {
                context: resources: {
                    limits: { memory: "512Mi" }
                    requests: { cpu: "50m", memory: "128Mi" }
                }
            }
        }
        flavor: string | *"small"
        _flavor[S.flavor]
    }
    ```

### Rule 5: Optional Modular "Clean Stack" Layout & Pure CUE Overlays
To manage highly complex application stacks (e.g., Traefik, Authelia) requiring auxiliary custom manifests (like Secrets, IngressRoutes, or custom CRs), stacks may optionally be organized into subdirectories under `mxc-library/stacks/`.

*   **Optional / Escape-Hatch Only:** This is strictly optional. Do not use this subdirectory nesting for simple or standard workloads (like game pods, single containers, etc.). Simple workloads must continue to use flat, single `.cue` files in `mxc-library/stacks/` to avoid unnecessary nesting and code boilerplate.
*   **Pure CUE Overlays (Zero-Jinja):** When using subdirectories, auxiliary custom manifests should be modeled natively as validated CUE configurations inside a `manifests/` or `overlays/` folder rather than using legacy hybrid Jinja-templated YAML files. They compile directly into static manifests at export time.
*   **Global Kustomize Namespace Injection Rule:** Never define or hardcode dynamic `namespace` fields inside individual overlay files or templates. Instead, define `namespace: xyz` under the application's Kustomize spec (`kustomize.namespace`). Kustomize automatically patches and injects that namespace onto all processed manifests in that directory context, keeping overlays extremely lean and decoupling manifest templates from deployment targets.

---

## 🎨 Best-Practice CUE Design Principles

We enforce a modern declarative paradigm for all library workloads:

### 1. Separate Workload Intent from Cluster Reality
*   **The Intent (`apps.cue` or stack definitions):** Focuses strictly on abstract developer requests (e.g., expose via ingress, require 10Gi of storage). It must never leak internal container ports or specific domain suffixes.
*   **The Reality (`cluster.cue` or environment overrides):** Maps logical intents to physical cluster capabilities (injecting `storageClass: "longhorn"`, base domains `yourdomain.com`, and VIP configurations).

### 2. Referential Integrity with Key-Mapping
To avoid duplicate key specifications (like typing `portName: "http"` inside an exposure map), design schemas so that **exposure keys correspond directly to service ports**. Always use CUE pattern-constraints and let-expressions to fail compilation if an exposure references an undefined port:
```cue
#App: {
    ports: [string]: #PortSpec
    expose: [PortName=string]: {
        let portCheck = ports[PortName]
        if portCheck == _|_ { _|_ } // Compile-time failure on invalid key mappings!
        
        target: "ingress" | "loadbalancer" | "internal"
    }
}
```

### 3. Use Deterministic Derived Identities
When modeling infrastructure identities derived from stable names, compute them in CUE instead of tracking them manually.
*   *Example:* Compute VM MAC addresses deterministically from hostnames so repeated renders stay stable and conflict-free.

### 4. Close Inner Schemas, Keep Outer Surfaces Open
Use CUE's `close({...})` on deep, typo-sensitive configuration blocks so invalid keys fail immediately during validation. Keep only the outermost integration points open with `...` where additive composition is explicitly intended, such as plugin-style extension surfaces.

### 5. Marshal Embedded YAML or JSON from Native CUE Values
If a CRD or rendered object needs an embedded YAML or JSON string payload, define that payload as native CUE data first and marshal it with `yaml.Marshal` or `json.Marshal`. This keeps embedded documents structurally validated at compile time instead of treating them as unchecked multiline strings.

---

## 🛠️ Local Development & Validation Workflow

Because `mxc-library` is decoupled from the main compilation kernel (`gitops-infra/mxc`), local testing requires invoking validation from the parent workspace.

### Workspace Setup
The library is packaged and published as an OCI artifact (see the root [README](../README.md#4-publishing-as-an-oci-package)). Consuming repositories such as `gitops-infra` pin a published `mxc-library` version in their own module dependencies — no symlinks or cross-repository tooling are needed to keep them in sync.

### Key Development Commands
You can run all validation and compilation commands directly from within the `mxc-library/` directory by calling `just` with parent scope parameters:

```bash
# 1. Validate all schemas and workload values against type constraints
just -f ../justfile -d .. mxc::validate

# 2. Compile and output flat parameters (vars.yml) to stdout to inspect the output
just -f ../justfile -d .. mxc::export

# 3. Export compiled values and save them directly for Kluctl deployment
just -f ../justfile -d .. mxc::export > ../cluster-home-mxc/vars.yml
```

> [!TIP]
> **Continuous Verification:** Before staging or opening a merge request, always run the validation suite to ensure that your library updates have not broken downstream environment compilations.
