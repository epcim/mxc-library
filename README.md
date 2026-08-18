# Model-X Configuration (MXC) Library

[**`epcim/mxc`**](https://github.com/epcim/mxc) is the core MXC compilation engine: it defines the base schemas, bootstrapping logic, and adapters that turn CUE workload definitions into rendered Kubernetes manifests. `mxc-library` (this repository) is the catalog that plugs into it — a standalone collection of ready-to-use workload stacks (applications) and deployer adapters, published as its own CUE module so teams and communities can distribute, mix, and contribute customized workloads without touching the engine itself.

* **CUE Module Name:** `github.com/epcim/mxc-library`
* **Core Engine Dependency:** [`github.com/epcim/mxc`](https://github.com/epcim/mxc) — [latest release](https://github.com/epcim/mxc/releases) (currently `v0.1.1`)

[![Catalog & Stack Documentation](https://img.shields.io/badge/Catalog-Stack%20Documentation-059669?style=for-the-badge)](https://epcim.github.io/mxc-library)

🚀 **Live Workload Catalog Documentation**: Explore our [GitHub Pages Catalog Site](https://epcim.github.io/mxc-library) to view our domain stacks, and interactive parameter blueprints.

---

## 1. Quick Start: Importing a Stack

Each application stack in `module/stacks/` is a plain CUE package. Add the module as a dependency, then import the stack you need and set values on it:

```cue
package mxc

import (
    s_infra "github.com/epcim/mxc-library/stacks/infra/traefik"
)

cluster: apps: infra: traefik: s_infra.#Traefik & {
    appFqdn: "traefik.example.com"
}
```

That's it — no symlinks, no cross-repo tooling. The stack definition, its Kubernetes manifests, and its adapter wiring all come from the published module.

---

## 2. The `#App` Schema: How a Stack Is Structured

Every stack builds on the core `#App` schema from `github.com/epcim/mxc/schema`. Values flow through it in layers, from identity down to the actual deployment artefact:

1. **Identity** — mandatory, top-level identity fields for the application: `appName`, `appDesc`, `appFqdn`.
2. **Shared configuration** — the per-app surfaces every stack fills in the same way: `context`, `values`, `secrets`, `platform`.
3. **Container intent** — fields like `image` and `expose` describe the workload's runtime shape. See the [`mxc` engine repository](https://github.com/epcim/mxc) for details; stacks in this library rarely need to touch these directly.
4. **Deployment artefacts** — the last tier, tracking the actual upstream rendering schema for the chosen adapter: `helmChart`, `k0rdent`, `kustomize`, and so on. At this tier, `values:` holds the native Helm values for the given chart (see `traefik.cue` in the example above for a full stack definition across all tiers).

---

## 3. Directory Structure

The repository separates the publishable CUE module from local tooling and docs:

```
mxc-library/
├── module/                    # Publishable github.com/epcim/mxc-library module
│   ├── cue.mod/
│   ├── schema/                # Vendored chart/CRD schemas
│   ├── bases/
│   ├── stacks/                # Application stacks — the actual workload catalog
│   │   ├── infra/
│   │   ├── media/
│   │   ├── monitoring/
│   │   └── ...
│   └── adapters/               # Library-specific deployer assets (Kluctl overlays, etc.)
├── utils/                      # Schema maintenance tools, not published
└── docs/                       # Documentation, not published
```

`module/stacks/` is the catalog itself: one subdirectory per domain (`infra`, `media`, `monitoring`, ...), each holding the application stacks you import as shown above.

Chart and CRD schemas registered in `module/schema/catalog.cue` can be refreshed with
the library-owned `cue cmd vendor-schema` workflow in `utils/vendor_tool.cue`.

---

## 4. Publishing as an OCI Package

The library pins a specific `github.com/epcim/mxc` version in `module/cue.mod/module.cue`. Publish core `mxc` first, then package and publish the library from this repository:

```bash
just oci-package v0.1.1
just oci-publish v0.1.1
```

Both commands resolve modules through `registry.cue`; private GHCR packages
require `GHCR_USER` and `GHCR_PAT` authentication.

Consuming repositories (e.g. `gitops-infra`) just pin the published version in their own module dependencies — no cross-repository tooling is required to keep them in sync.

---

## 5. Multi-Library Composition (Mixing & Extending Portfolios)

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

## 6. Sharing and Contributing Back

When you create new stacks or improve adapters locally:
1. Stage your changes in `mxc-library`.
2. Push your branch upstream to your fork of `mxc-library`.
3. Open a Merge Request (MR) back to the original `github.com/epcim/mxc-library` repository.

This approach guarantees an extremely flexible, distributed workspace where you can safely customize infrastructure without losing the option to collaborate and push features back to the community upstream.
