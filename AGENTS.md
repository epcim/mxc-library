# mxc-library Agent Handbook

This document provides context, directory structures, and design guidelines for AI agents working on the **`mxc-library`** repository.

---

## 🏛️ Directory Structure

The repository is structured as follows:

```text
mxc-library/
├── AGENTS.md                   # This instruction file
├── README.md                   # General developer guide
├── adapters/                   # Platform-specific adapters
│   ├── app_template/
│   │   └── projection.cue      # CUE logical pass-through pointing to mxc core
│   ├── kluctl/
│   │   ├── projection.cue      # CUE logical pass-through pointing to mxc core
│   │   ├── helm-chart.yml      # Base templates (physical copy for OCI)
│   │   ├── helm-values.yml
│   │   ├── kustomization.yml
│   │   ├── vars.yml
│   │   └── overlays/           # Core and Library overlays
│   │       ├── pvc.yaml        # Base overlays (physical copy for OCI)
│   │       ├── authelia/       # App-specific custom overlays
│   │       └── netbird/        # App-specific custom overlays
│   └── kustomize-only/
│       ├── kustomization.yml   # Base template (physical copy for OCI)
│       └── vars.yml
├── bases/                      # Core system bootstrapping (namespaces, kube-system, metallb)
├── stacks/                     # Production-ready service stacks
│   ├── cicd/                   # CI/CD planes (Woodpecker, Renovate, Harbor)
│   ├── game/                   # Standalone workloads (2048, Pacman, Tetris)
│   ├── infra/                  # Core infrastructure (Hass, Traefik, Monitoring)
│   ├── media/                  # Media streaming (Emby, Silo)
│   ├── networking/             # Advanced overlays (NetBird, Traefik routes)
│   └── storage/                # Storage planes (Longhorn)
└── docs/                       # Per-application architecture & deployment guides
```

---

## 🛡️ Core Rules for Library Maintenance

### Rule 1: No Duplicate Active Code Logic
* To avoid code drift, all active logical projections and type schemas **must belong strictly to the base `mxc` repository**.
* Any logical `projection.cue` file inside the `mxc-library` directory must act as a **pass-through delegation alias** importing and inheriting dynamically from the `github.com/epcim/mxc/...` namespace.

### Rule 2: Standalone OCI Portability for Templates
* Static `.yml` or `.yaml` template files (e.g. `helm-chart.yml`, `kustomization.yml`, etc.) must exist as physical copies in both repositories.
* **Never use OS-level symbolic links or relative parent path traversals (`../`)** for static template assets inside the library adapters. This ensures the library can be packaged and extracted as an independent OCI container in production without broken dependencies.

### Rule 3: Application-Specific Overlays Location
* Completely generic overlays (such as base PersistentVolumeClaims, standard rollout cronjobs, or base NetworkPolicies) belong inside `mxc/adapters/kluctl/overlays/`.
* Application-specific overlays (such as specialized configmaps, ingress overrides, or secret generation for Authelia, NetBird, or Traefik) belong strictly inside `mxc-library/adapters/kluctl/overlays/`.

### Rule 4: Centralization of Common Stack Defaults
* Standard platform configurations, deployment tags, ports, sizing presets, resources, and credentials schemas (such as Velero S3/Minio bucket templates, standard credential structures, and common ingress mappings) must be declared as native defaults directly inside the stack CUE files (e.g. `mxc-library/stacks/infra/velero.cue`).
* Cluster-level environment CUE files must only declare the stack import and any local overrides, keeping the environment configurations perfectly lean and minimal (e.g. `velero: stk_infra.#Velero` without redundant duplicate blocks).

### Rule 5: Optional Modular "Clean Stack" Layout
* To manage highly complex application stacks (e.g., Traefik, Authelia) requiring auxiliary custom manifests (like Secrets, IngressRoutes, or custom CRs), stacks may optionally be organized into subdirectories under `mxc-library/stacks/`.
* **Optional / Escape-Hatch Only:** This is strictly optional. Do not use this subdirectory nesting for simple or standard workloads (like game pods, single containers, etc.). Simple workloads must continue to use flat, single `.cue` files in `mxc-library/stacks/` to avoid unnecessary nesting and code boilerplate.

---

## 🛠️ Local Agent Skills

* This subrepository's operations are governed by a repository-level dedicated agent skill located at:
  [**`.agents/skills/mxc/SKILL.md`**](file:///Users/p.michalec/Workspace/gitea/gitops-infra/.agents/skills/mxc/SKILL.md) (relative to the project root).
* AI Agents working on CUE configurations, schemas, or adapters **must read and follow** the detailed compilation, layout, and output checklists defined in that skill!
