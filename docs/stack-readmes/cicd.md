# CI/CD Service Stack

This directory contains declarative, schema-validated configuration wrappers for our central continuous integration, container registry, and dependency automated update plane.

## 📦 Stack Components

* **`harbor.cue`**: Enterprise-grade container registry managing images, charts, and OCI signatures.
* **`woodpecker.cue`**: Community-driven, lightweight continuous integration engine executing pipelines inside containers.
* **`renovate.cue`**: Automated dependency update bot keeping Helm charts, container tags, and library schemas synchronized.

---

## 🛠️ Usage & Configuration

Applications are enabled by adding them to your cluster's declarative `apps` list:

```cue
# Example cluster-home-mxc integration
package apps

import "github.com/epcim/mxc-library/stacks/cicd"

apps: {
    renovate: cicd.#Renovate & {
        // Customize parameters here
    }
    woodpecker: cicd.#Woodpecker & {
        // Customize parameters here
    }
}
```

---

## 🤖 Renovate + Woodpecker CI Integration Guide

To run automatic dependency updates inside your private Woodpecker CI instance, follow this setup:

### 1. Configure the Woodpecker Pipeline
Add a `.woodpecker.yml` file to the root of your GitOps repository to run Renovate on a cron schedule or on manual trigger:

```yaml
# .woodpecker.yml
when:
  - event: cron
    cron: renovate
  - event: manual

steps:
  - name: renovate
    image: renovate/renovate:38.0.0
    environment:
      RENOVATE_PLATFORM: gitea
      RENOVATE_ENDPOINT: "https://git.your-domain.net" # Endpoint URL to your Forgejo/Gitea instance
      RENOVATE_TOKEN:
        from_secret: renovate_token                  # Secret token with repo write permissions
      RENOVATE_GIT_AUTHOR: "Renovate Bot <renovate@your-domain.net>"
      RENOVATE_REPOSITORIES: "epcim/gitops-infra"
      LOG_LEVEL: info
```

### 2. Configure the Secret Token
To generate your `renovate_token`:
1. In Forgejo/Gitea, go to **Settings ➔ Applications ➔ Generate Token**.
2. Give it write access to repository contents and pull requests.
3. Add this token inside Woodpecker as a repository secret named `renovate_token`.

### 3. Setting Up the Cron Schedule
1. Open the Woodpecker UI.
2. Go to your repository **Settings ➔ Cron Jobs**.
3. Create a new cron named `renovate` running weekly or nightly (e.g. `0 2 * * *`).
