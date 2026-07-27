# Model-X Configuration (MXC) Library

This is the standard workload composition and rendering adapter library for the MXC Platform ecosystem. It is designed to be completely independent from the core compilation engine, allowing teams and communities to distribute, mix, and contribute customized workloads.

* **CUE Module Name:** `github.com/epcim/mxc-library`
* **Local Workspace Directory:** `/mxc-library/`

---

## 1. Directory Structure

This library separates the logical application definition (the "content") from the physical render orchestrator (the "adapters"):

```
mxc-library/
├── cue.mod/                   # CUE Module metadata
│   └── module.cue             # Declares module name: "github.com/epcim/mxc-library"
├── stacks/                    # CUE workload declarations (The Content)
│   ├── cicd/                  # Woodpecker, Renovate, Forgejo
│   ├── game/                  # Game namespaces and isolated workloads
│   ├── infra/                 # Core utilities (MetalLB, Traefik, Grafana, Loki)
│   ├── media/                 # Storage-heavy media stacks (Emby, Silo)
│   └── networking/            # NetBird client gateways, DNS stacks
└── adapters/                  # Rendering Adapters (The Engine Bindings)
    └── kluctl/                # Kluctl-specific render adapters
        ├── helm-chart.yml     # Standard Helm chart fetch specification
        ├── helm-values.yml    # Parameter-to-values binding
        ├── kustomization.yml  # Kustomize list of resources
        ├── overlays/          # PVCs, NetworkPolicies, custom ConfigMaps
        └── vars.yml           # Base bindings and default values
```

---

## 2. Multi-Library Composition (Mixing & Extending Portfolios)

Because CUE values are merged via **unification (`&`)**, you can import and mix multiple independent CUE libraries seamlessly. If you create a customized stack library, you can import it beside this one:

```cue
package mxc

import (
    s_infra "github.com/epcim/mxc-library/stacks/infra"
    s_user  "github.com/someone/custom-mxc-library/stacks/custom"
)

cluster: apps: {
    infra: {
        traefik: s_infra.#Traefik
    }
    custom: {
        my_service: s_user.#CustomApp
    }
}
```

---

## 3. Parallel Multi-Repo Development with `git-cross`

To make it incredibly simple for users to participate, edit stacks/adapters, and share their contributions back from **Day 1**, we recommend using **`git-cross`** (https://github.com/epcim/git-cross).

`git-cross` allows managing cross-repository development dependencies seamlessly, binding your active cluster infrastructure repo (`gitops-infra`) with this independent workload library repo (`mxc-library`).

### Installation

Install `git-cross` on your local system:
```bash
# Clone and install git-cross
git clone https://github.com/epcim/git-cross.git ~/.git-cross
# Or follow instructions at https://github.com/epcim/git-cross for shell aliases
```

### local Workflow Configuration

Configure a local workspace cross-boundary mapping so that modifications inside the library can be tracked, committed, and contributed back alongside your deployment configurations:

1. **Local Symbolic Link (Created by Default):**
   CUE package compilation uses a symlink inside the cluster configuration to resolve local edits instantly:
   ```
   cluster-home-mxc/cue.mod/pkg/github.com/epcim/mxc-library ➡️ ../../../../../mxc-library
   ```
2. **Track Cross-Commit Changes:**
   Use `git-cross` commands to synchronize branch staging and ensure cross-repo boundaries are kept in lock-step:
   ```bash
   # Status across both gitops-infra and mxc-library repositories
   git cross status

   # Commit changes across repositories simultaneously with a unified commit message
   git cross commit -am "infra: update grafana community dashboard references and bump schema version"
   ```

### Sharing and Contributing Back

When you create new stacks or improve adapters locally:
1. Stage your changes in `mxc-library`.
2. Push your branch upstream to your fork of `mxc-library`.
3. Open a Merge Request (MR) back to the original `github.com/epcim/mxc-library` repository.

This approach guarantees an extremely flexible, distributed workspace where you can safely customize infrastructure without losing the option to collaborate and push features back to the community upstream.
