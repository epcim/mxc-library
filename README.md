# Model-X Configuration (MXC) Library

This is the standard workload composition and rendering adapter library for the MXC Platform ecosystem. It is designed to be completely independent from the core compilation engine, allowing teams and communities to distribute, mix, and contribute customized workloads.

[![Catalog & Stack Documentation](https://img.shields.io/badge/Catalog-Stack%20Documentation-059669?style=for-the-badge)](https://epcim.github.io/mxc-library)

🚀 **Live Workload Catalog Documentation**: Explore our [GitHub Pages Catalog Site](https://epcim.github.io/mxc-library) to view our domain stacks, and interactive parameter blueprints.

* **CUE Module Name:** `github.com/epcim/mxc-library`
* **Local Workspace Directory:** `/mxc-library/`


---

## 1. Directory Structure

This library separates the logical application definition (the "content") from the physical render orchestrator (the "adapters"):

```
mxc-library/
├── module/                    # Publishable github.com/epcim/mxc-library module
│   ├── cue.mod/
│   ├── schema/
│   ├── bases/
│   ├── stacks/                # Reusable workload definitions
│   └── adapters/              # Library-specific deployer assets
├── utils/                     # Schema maintenance tools, not published
└── docs/                      # Documentation, not published
```

Chart and CRD schemas registered in `module/schema/catalog.cue` can be refreshed with
the library-owned `cue cmd vendor-schema` workflow in `utils/vendor_tool.cue`.

The library pins `github.com/epcim/mxc@v0.1.0`. Publish core MXC first, then
package and publish the library from this repository:

```bash
just oci-package v0.1.0
just oci-publish v0.1.0
```

Both commands resolve modules through `registry.cue`; private GHCR packages
require `GHCR_USER` and `GHCR_PAT` authentication.

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
   cluster-home-mxc/cue.mod/pkg/github.com/epcim/mxc-library ➡️ ../../../../../mxc-library/module
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
