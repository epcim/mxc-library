# Model-X Configuration (MXC) Library

**mxc-library is an application catalog.**

[**`epcim/mxc`**](https://github.com/epcim/mxc) is the core MXC compilation engine: it defines the base schemas, bootstrapping logic, and adapters that turn CUE workload definitions into rendered Kubernetes manifests. `mxc-library` (this repository) is the catalog that plugs into it — a standalone collection of ready-to-use workload stacks (applications) and deployer adapters, published as its own CUE module so teams and communities can distribute, mix, and contribute customized workloads without touching the engine itself.

* **CUE Module Name:** `github.com/epcim/mxc-library`
* **Core Engine Dependency:** [`github.com/epcim/mxc`](https://github.com/epcim/mxc) — [latest release](https://github.com/epcim/mxc/releases)

[![Catalog & Stack Documentation](https://img.shields.io/badge/Catalog-Stack%20Documentation-059669?style=for-the-badge)](https://epcim.github.io/mxc-library)

🚀 **Live Workload Catalog Documentation**: Explore our [GitHub Pages Catalog Site](https://epcim.github.io/mxc-library) to view our domain stacks, and interactive parameter blueprints.
 
At its core, **MXC is just `cue export` of unified variable trees and configurations**. 

Adapters simply transform this exported data into native input formats for whatever deployment or provisioning tool you choose: **Kluctl, Kustomize, K0rdent, Terraform / OpenTofu, Helm, or ArgoCD**.

```text
                      ┌────────────────────────────────────────┐
                      │       just mxc::apply TARGET           │
                      └──────────────────┬─────────────────────┘
                                         │
                         CUE evaluates adapter for tag
                                         │
             ┌───────────────────────────┼───────────────────────────┬───────────────────────────┐
             ▼                           ▼                           ▼                           ▼
     ┌───────────────┐           ┌───────────────┐           ┌───────────────┐           ┌───────────────┐
     │    kluctl     │           │   kustomize   │           │    k0rdent    │           │   terraform   │
     └───────┬───────┘           └───────┬───────┘           └───────┬───────┘           └───────┬───────┘
             │                           │                           │                           │
      kluctl deploy ...        kustomize build /           kcm apply /                 tofu / terraform
                               kubectl apply -f            kubectl apply -f CR         apply ...
```

---

## 1. Quick Start: Importing a Stack

Each application stack in `module/stacks/` is a plain CUE package. Add the module as a dependency, then import the stack you need and set values on it:

```cue
package mxc

import (
    infra "github.com/epcim/mxc-library/stacks/infra/traefik"
)

cluster: apps: infra: traefik: infra.#Traefik & {
    appFqdn: "traefik.example.com"
}
```

That's it — no symlinks, no cross-repo tooling. The stack definition, its Kubernetes manifests, and its adapter wiring all come from the published module.

---

## 2. The `#App` Schema: How a Stack Is Structured

Every stack builds on the core `#App` schema from `github.com/epcim/mxc/schema`. The schema has five layers. Each layer adds one kind of information.

1. **Identity.** Name and describe the application: `appName`, `appDesc`, `appFqdn`, `tags`.
2. **Adapter selection.** Pick the tool that turns this stack into manifests: `adapter` (default `"kluctl"`).
3. **Configuration surface.** Set typed values for the app: `values`, `valuesSchema`, `flavor` (a sizing preset), `platform`.
4. **Container intent.** Describe the workload itself: `image`, `ports`, `expose`, `storage`, `secrets`. Most stacks in this library do not set these fields by hand. See the [`mxc` engine repository](https://github.com/epcim/mxc) for the full field list.
5. **Deployment artefacts.** Wire the app to its adapter: `helmChart` for a Helm chart, `kustomize` for extra manifests and patches, `k0rdent` for Mirantis k0rdent services. At this layer, `values:` holds the native Helm values for the chosen chart.

CUE checks all five layers together, at compile time, before anything reaches a cluster. A stack author writes the schema once. Every consumer gets type checks, defaults, and field documentation for free. Section 3 shows all five layers in one real file.

---

## 3. A Full Stack in One File

This example is a trimmed version of the real `traefik.cue` stack in `module/stacks/infra/traefik/`. It shows identity, sizing, Helm chart wiring, typed values, and an extra Kubernetes object, all in one file:

```cue
package traefik

import "github.com/epcim/mxc/schema"

#Traefik: schema.#App & {
    appName: "traefik"
    tags: ["infra", "traefik"]

    // Sizing presets. One word selects a full resource profile.
    flavor: string | *"small"
    _flavor: {
        small: values: resources: {
            limits:   {cpu: "500m", memory: "512Mi"}
            requests: {cpu: "200m", memory: "256Mi"}
        }
        large: values: resources: {
            limits:   {cpu: "2", memory: "2Gi"}
            requests: {cpu: "500m", memory: "1Gi"}
        }
    }

    // Helm chart wiring: chart, version, namespace.
    deployment: "kluctl"
    helmChart: {
        repo:         "https://traefik.github.io/charts"
        chartName:    "traefik"
        chartVersion: "34.2.0"
        namespace:    kustomize.namespace
    }

    // Extra manifests rendered next to the Helm output.
    kustomize: {
        namespace: string | *"sys"
        resources: [...string] | *[
            "helm-rendered.yaml",
            "overlays/traefik/cloudflare-api.yml",
        ]
    }

    // Typed native Helm values. A wrong key or a wrong type fails at compile time.
    values: {
        service: loadBalancerSourceRanges: [...string] | *[
            "172.31.0.0/12", "192.168.0.0/16", "10.0.0.0/8",
        ]
        ports: websecure: tls: certResolver: string | *"cloudflare"
    }

    _flavor[flavor]
}
```

A user of this stack sets one field, `appFqdn`, and gets a full, checked Traefik deployment (see [section 1](#1-quick-start-importing-a-stack)).

### Why CUE and MXC, not plain Helm

| Concern | Plain Helm | CUE + MXC |
|---|---|---|
| Value types | Checked at install time, in the cluster | Checked at compile time, on your machine |
| Defaults and docs | Spread across `values.yaml`, `values.schema.json`, and a README | Live next to each field, in one place |
| Sizing presets | Copied `values-small.yaml`, `values-large.yaml` files | One `flavor` field selects a preset |
| Extra Kubernetes objects (Secrets, Middlewares, patches) | A separate Kustomize overlay repo, wired by hand | `kustomize.resources`, in the same file as the chart |
| Reuse across teams | Copy the chart, edit by hand, values drift over time | Import the CUE package, unify (`&`) with your own overrides |
| Merge of many sources | `helm template`, then a manual `kubectl patch` or a second Kustomize pass | One CUE unification (`&`) across all sources |

CUE finds a wrong field name, a wrong type, or a missing required value before anything reaches the cluster. A Helm template cannot do this: it renders whatever text you give it, correct or not.

---

## 4. Patching Helm Output: New Objects and Field Patches

The `kustomize:` block does two jobs. It adds new objects next to a stack's own manifests, and it patches fields inside objects a chart already created. Both jobs stay in the same CUE file as the rest of the stack.

### Start simple: `kustomize:` on its own

`kustomize:` needs no Helm chart at all. List plain manifest files under `resources`, and CUE checks the rest of the stack around them:

```cue
kustomize: {
    namespace: "home"
    resources: ["configmap.yaml"]
}
```

### Add a Helm chart, then add a new object: a Secret

When a stack also sets `helmChart`, the render step writes the chart's own output to a file named `helm-rendered.yaml`. List that file in `kustomize.resources` next to any extra manifest, and both deploy together. The Traefik stack above lists `overlays/traefik/cloudflare-api.yml`, a plain Kubernetes `Secret`:

```yaml
{% if get_var('overlays.cloudflare_api', false) %}
---
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api
  namespace: {{ overlays.cloudflare_api.namespace | default("sys") }}
stringData:
  {{ args.domain }}: {{ secrets.traefik.resolver.cloudflare.tokens[args.domain] }}
{% endif %}
```

One toggle, `overlays.cloudflare_api`, turns this file on or off. Turn the toggle on, and the Secret deploys with the chart, in the same `kustomize` pass — no second pipeline, no manual `kubectl apply` step.

### Patch a field inside an object the chart already made

Use `kustomize.patches` to change a field on an object the Helm chart renders, without touching the chart. This example, from a cluster stack for `hajimari`, turns on `readOnlyRootFilesystem` on the container the chart's `Deployment` already creates:

```cue
patches: [{
    target: {kind: "Deployment", name: "hajimari"}
    patch: "spec: {template: {spec: {containers: [{name: hajimari, securityContext: {readOnlyRootFilesystem: true}}]}}}"
}]
```

`target` finds the object by `kind` and `name`; `patch` is a strategic merge patch, applied on top of it. The same field stays type-checked CUE text, next to every other setting for this app — not a separate patch file in a separate repo. The same mechanism also supports `$patch: delete`, to remove an object the chart created.

---

## 5. Directory Structure

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
│   └── adapters/               # Output adapters
├── utils/                      # Schema maintenance tools, not published
└── docs/                       # Documentation, not published
```

`module/stacks/` is the catalog itself: one subdirectory per domain (`infra`, `media`, `monitoring`, ...), each holding the application stacks you import as shown above.

Chart and CRD schemas registered in `module/schema/catalog.cue` can be refreshed with
the library-owned `cue cmd vendor-schema` workflow in `utils/vendor_tool.cue`.

---

## 6. Publishing as an OCI Package

The library pins a specific `github.com/epcim/mxc` version in `module/cue.mod/module.cue`. Publish core `mxc` first, then package and publish the library from this repository:

```bash
just oci-package v0.1.1
just oci-publish v0.1.1
```

Both commands resolve modules through `registry.cue`; private GHCR packages
require `GHCR_USER` and `GHCR_PAT` authentication.

Consuming repositories (e.g. `gitops-infra`) just pin the published version in their own module dependencies — no cross-repository tooling is required to keep them in sync.

---

## 7. Multi-Library Composition (Mixing & Extending Portfolios)

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

## 8. Sharing and Contributing Back

When you create new stacks or improve adapters locally:
1. Stage your changes in `mxc-library`.
2. Push your branch upstream to your fork of `mxc-library`.
3. Open a Merge Request (MR) back to the original `github.com/epcim/mxc-library` repository.

This approach guarantees an extremely flexible, distributed workspace where you can safely customize infrastructure without losing the option to collaborate and push features back to the community upstream.
