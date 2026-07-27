# CI/CD Stack Documentation

This directory contains advanced architecture and integration guides for the Continuous Integration, Container Registry, and Automated Dependency Update plane.

---

## 📦 Stack Components

* [**Harbor Container Registry**](#-harbor-container-registry)
* [**Woodpecker CI**](#-woodpecker-ci)
* [**Renovate Bot**](#-renovate-bot)
* [**Renovate + Woodpecker CI Integration**](#-renovate--woodpecker-ci-integration)

---

## ⚓ Harbor Container Registry

Harbor serves as the secure enterprise OCI registry for container images, Helm charts, and custom CUE/MXC packages.

### 1. Storage backend & PVCs
Harbor allocates distinct PersistentVolumeClaims for registries, databases, and logs:
* `harbor-registry`: Persists OCI image blobs (default size: `50Gi`).
* `database-data-harbor-database-0`: Stores user permissions, metadata, and vulnerability scan logs.

### 2. Dropping & Recreating PVCs (Troubleshooting)
If registry volumes fail to mount (e.g. `ContainerCreating` state during filesystem mismatch), the existing volumes can be cleanly dropped and recreated:
```bash
# Delete Harbor pods and statefulsets to release volume bindings
kubectl -n gitops delete statefulset harbor-database harbor-redis harbor-trivy
kubectl -n gitops delete deploy harbor-registry harbor-core harbor-jobservice

# Delete target PVCs
kubectl -n gitops delete pvc harbor-registry database-data-harbor-database-0

# Re-deploy the stack via Kluctl
just TARGET=cluster-home-mxc deploy harbor
```

---

## 🐦 Woodpecker CI

Woodpecker provides lightweight containerized pipelines.

### 1. Security Context & Permissions
Woodpecker runs as non-root UID `1000`. To prevent sqlite migration locks (`SQLITE_CANTOPEN`), the following security constraints are applied to the server pod:
```yaml
podSecurityContext:
  fsGroup: 1000
  fsGroupChangePolicy: OnRootMismatch
securityContext:
  runAsUser: 1000
  runAsGroup: 1000
```

---

## 🤖 Renovate Bot

Renovate runs as an in-cluster scheduled or manually triggered dependency update bot.

### 1. Repository Configuration
The current stack configuration lives inside the `stack/cicd/vars.yml` settings model:
* **Platform**: `gitea`
* **Target Repositories**: `epcim/gitops-infra` by default.
* **API Endpoint**: `https://forgejo.aalive.familyds.net/` (default Forgejo URL).

### 2. Secret & Tokens Setup
Add your Gitea personal access token to `cluster-home/vars-sec.yml` and encrypt it using SOPS:
```yaml
secrets:
  renovate:
    token: "<your-gitea-token>"
```
The token is automatically passed to the container as the `RENOVATE_TOKEN` environment variable.

### 3. Recommended Gitea/Forgejo Bot Account Permissions
Use a dedicated bot-style account (e.g., `renovate`). Ensure the account has:
* **Write Access** to the repository (to push branches, open pull requests, and manage issue comments).

### 4. Direct Apply Command
To trigger or re-deploy the Renovate service:
```bash
just TARGET=cluster-home-mxc apply --include-tag renovate
```

---

## 🔗 Renovate + Woodpecker CI Integration

To automate GitOps dependency upgrades using Renovate within your private Woodpecker runners:

### 1. Define the Pipeline
Add `.woodpecker.yml` to the root of your GitOps repository:
```yaml
when:
  - event: cron
    cron: renovate
  - event: manual

steps:
  - name: run-renovate
    image: renovate/renovate:38.0.0
    environment:
      RENOVATE_PLATFORM: gitea
      RENOVATE_ENDPOINT: "https://forgejo.aalive.familyds.net/"
      RENOVATE_TOKEN:
        from_secret: renovate_token
      RENOVATE_GIT_AUTHOR: "Renovate Bot <renovate@yourdomain.com>"
      RENOVATE_REPOSITORIES: "epcim/gitops-infra"
      LOG_LEVEL: info
```

### 2. Configure Token & Secrets
1. Go to your **Gitea/Forgejo ➔ Settings ➔ Applications** and generate a Personal Access Token with repository write permissions.
2. In the Woodpecker web UI, add this token as a repository secret named `renovate_token`.
3. Create a **Cron Job** in Woodpecker settings named `renovate` scheduled to run on your desired frequency (e.g. daily at 2:00 AM: `0 2 * * *`).
