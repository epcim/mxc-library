---
name: mxc-library-skill
description: Provides instruction patterns, directory rules, CUE design principles, and execution workflows for AI agents tasked with modifying or extending the MXC Workload Library.
---

# Local Agent Skill: MXC Workload Library Development & Best Practices

* **Name:** `mxc-library-skill`
* **Description:** Dedicated developer guidelines and execution workflows for AI agents tasked with editing, extending, or documenting the MXC Workload Library (`mxc-library`).

---

## 🚀 Welcome, Agent!

This repository contains **mxc-library**, the standard workload composition and rendering adapter library for the MXC Platform. 

As an agent working on this library, your primary mission is to define stable, tool-agnostic workload definitions ("The Content") inside `stacks/` and maintain clean, physical bindings ("The Adapters") inside `adapters/`.

Before writing any CUE configurations, creating overlays, or writing documentation, you **MUST** read, understand, and strictly follow these development rules, design principles, and execution workflows.

---

## ⚡ Key Commands

Never write raw shell scripts or hardcoded path hacks. Always use the parent directory's nested `just` task runner to compile, export, and validate your changes:

```bash
# 1. Validate all CUE schemas, parameters, and workloads against type constraints
just -f ../justfile -d .. mxc::validate

# 2. Compile and output flat parameters (vars.yml) to stdout to inspect the layout
just -f ../justfile -d .. mxc::export

# 3. Compile and save validated parameters directly for Kluctl deployment
just -f ../justfile -d .. mxc::export > ../cluster-home-mxc/vars.yml

# 4. Check git status across parallel repositories simultaneously (using git-cross)
git cross status

# 5. Commit changes across parallel repositories with a unified commit message
git cross commit -am "infra: update ingress definitions and bump schema version"
```

---

## 🛡️ Core Rules for Library Maintenance

To prevent code drift and ensure complete portability across local environments and OCI production registries, adhere to these five core commandments:

### Rule 1: No Duplicate Active Code Logic
All active logical projections and type schemas **must belong strictly to the base `mxc` repository**. Any logical `projection.cue` file inside the `mxc-library` directory must act as a **pass-through delegation alias** importing and inheriting dynamically from the `github.com/epcim/mxc/...` namespace.
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

### Rule 5: Optional Modular "Clean Stack" Layout & Pure CUE Overlays
To manage highly complex application stacks (e.g., Traefik, Authelia) requiring auxiliary custom manifests (like Secrets, IngressRoutes, or custom CRs), stacks may optionally be organized into subdirectories under `mxc-library/stacks/`.

*   **This is strictly optional:** Do NOT use subdirectories for simple deployments (e.g. game pods, single containers, lightweight utilities). Flat `.cue` files in `mxc-library/stacks/` remain the standard, cleanest way to avoid unnecessary boilerplate.
*   **Pure CUE Overlays (Zero-Jinja):** When using subdirectories, auxiliary custom manifests should be modeled natively as validated CUE configurations inside a `manifests/` or `overlays/` folder rather than using legacy hybrid Jinja-templated YAML files. They will compile directly into static manifests at export time.
*   **Global Kustomize Namespace Injection Rule (Best Practice):** Never define or hardcode dynamic `namespace` fields inside individual overlay files or templates. Instead, define `namespace: xyz` under the application's Kustomize spec (`kustomize.namespace`). Kustomize automatically patches and injects that namespace onto all processed manifests in that directory context, keeping overlays extremely lean and decoupling manifest templates from deployment targets.

---

## 🎨 CUE Design & Authoring Best Practices

When extending or creating workload definitions, apply the following patterns:

### 1. Separate Workload Intent from Cluster Reality
*   **Workload spec (`apps.cue` or stack definitions):** Focuses strictly on abstract developer requests (e.g., `expose: target: "ingress"`, storage sizes). Never leak internal container ports or specific domain suffixes here.
*   **Infrastructure spec (`cluster.cue`):** Maps logical intents to physical cluster capabilities (injecting `storageClass: "longhorn"`, base domains `yourdomain.com`, and VIP configurations).

### 2. Native Pluggable Adapter Pattern
Do not pollute core schemas with target-specific properties. If you need to generate ArgoCD CRDs, Terragrunt variables, or Prometheus rules, implement a custom adapter extending the abstract `#Adapter` interface.

### 3. Referential Integrity with Key-Mapping
To avoid duplicate key specifications (like typing `portName: "http"` inside an exposure map), design schemas so that **exposure keys correspond directly to service ports**. Always use CUE pattern-constraints and let-expressions to fail compilation if an exposure references an undefined port:
```cue
#AppCore: {
    ports: [string]: #PortSpec
    expose: [PortName=string]: {
        let portCheck = ports[PortName]
        if portCheck == _|_ { _|_ } // Compile-time failure on invalid key mappings!
        
        target: "ingress" | "loadbalancer" | "internal"
    }
}
```

### 4. Close Inner Schemas, Keep Outer Extension Surfaces Open
Use `close({...})` on deep, typo-sensitive configuration blocks so invalid keys fail immediately during validation. Keep only the outermost integration points open with `...` where additive composition is explicitly intended, such as plugin-style extension surfaces.

### 5. Marshal Embedded YAML or JSON from Native CUE Values
If a CRD or rendered object needs an embedded YAML or JSON string payload, define that payload as native CUE data first and marshal it with `yaml.Marshal` or `json.Marshal`. This keeps embedded documents structurally validated at compile time instead of treating them as unchecked multiline strings.

### 6. Leverage Sizing Presets (Flavors)
Always define resource limits and requests inside a private `_flavor` map inside your stack schema, keyed by `flavor` string. This allows environment configurations to scale resources instantly (e.g. from `small` to `medium` or `large`) without repeating resource blocks:
```cue
#MyWorkload: S=schema.#AppCore & {
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

### 7. Derive, Don't Duplicate
When a single logical value (an FQDN, a URL built from it, a hostname list) is needed in more than one place inside or across a struct, define it once and reference it everywhere else — never repeat the literal. A repeated literal is a latent bug: the copies drift apart the moment one is edited and the other is forgotten.

*   **Same-level sibling reference** — when both fields live in the same struct literal, reference the sibling directly by name, no alias needed:
    ```cue
    context: {
        expose: ingress: hosts: core: string
        externalURL: "https://\(expose.ingress.hosts.core)"  // harbor.cue
    }
    ```
*   **Cross-level reference via the `S=` self-alias** — when the second usage sits deeper than the field it needs (e.g. a hand-rolled `context.ingress` needing the top-level `expose.http.fqdn`), reference the stack's own `S=schema.#AppCore & { ... }` alias instead of a second hardcoded literal:
    ```cue
    #Authelia: S=schema.#AppCore & {
        context: ingress: main: hosts: [{host: S.expose.http.fqdn}]
    }
    ```

### 8. Cross-App Context References as Composition
Stack files inside the same `mxc-library/stacks/<category>` directory (e.g. `stacks/monitoring/`) share one CUE package, so CUE resolves identifiers at the package level, not per-file. A definition in one file can reference another definition's fields directly by name, with no import needed — e.g. `#Grafana` referencing `#Mimir.kustomize.namespace` or `#Loki.appName` directly instead of each app hardcoding the others' namespace/service name. This only applies within the same package (same category directory); across categories, wiring belongs at the `cluster-home-mxc/apps-*.cue` override layer instead.

---

## 🛠️ Verification Checklist (Before Ending Your Turn)

1.  **Verify Compilation & Validation:** Always run the validation command using the parent repository context before completing your task:
    ```bash
    just -f ../justfile -d .. mxc::validate
    ```
    Ensure it finishes with **code 0** and prints:
    `🎉 SUCCESS: All Model-X Configuration (MXC) validations passed perfectly!`
2.  **Verify Parameter Export:** Run compilation and check that the flat variables compile successfully:
    ```bash
    just -f ../justfile -d .. mxc::export
    ```
3.  **Check Git Cross Status:** Run status to ensure both repositories (`gitops-infra` and `mxc-library`) are in sync:
    ```bash
    git cross status
    ```
4.  **No Manual Overrides:** Never manually edit `cluster-home-mxc/vars.yml` or downstream configs. Always apply updates to the CUE sources in the library/environments and regenerate the variables using the export task runner.
