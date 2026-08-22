set shell := ["bash", "-cu"]

mod? schema 'just/schema.just'

root := env_var_or_default("GIT_ROOT", `git rev-parse --show-toplevel 2>/dev/null || pwd`)
GHCR_USER := env('GHCR_USER', '')
OCI_VERSION := env('OCI_VERSION', '')
_module_dir := if path_exists(root + "/module/cue.mod") == "true" { root + "/module" } else { source_dir() + "/module" }
_registry_config := "file:" + root + "/registry.cue"

[group('oci')]
[no-cd]
ghcr-status:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "GHCR_USER={{ GHCR_USER }}"
    if [[ -n "${GHCR_PAT:-}" ]]; then
        echo "GHCR_PAT=set"
    else
        echo "GHCR_PAT=unset"
    fi

[group('oci')]
[no-cd]
ghcr-login:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -z "${GHCR_USER:-{{ GHCR_USER }}}" ]]; then
        echo "GHCR_USER is required; set GHCR_USER environment variable" >&2
        exit 1
    fi
    if [[ -z "${GHCR_PAT:-}" ]]; then
        echo "GHCR_PAT is required; refusing GHCR login" >&2
        exit 1
    fi
    user="${GHCR_USER:-{{ GHCR_USER }}}"
    printf '%s' "$GHCR_PAT" | docker login ghcr.io -u "$user" --password-stdin

[group('oci')]
oci-package version=OCI_VERSION *args="":
    #!/usr/bin/env bash
    set -euo pipefail
    export CUE_REGISTRY='{{ _registry_config }}'
    cd '{{ _module_dir }}'
    cue mod tidy --check
    cue vet ./...
    cue mod publish "{{ version }}" --dry-run --json {{ args }}

[group('oci')]
oci-publish version=OCI_VERSION *args="": ghcr-login
    #!/usr/bin/env bash
    set -euo pipefail
    export CUE_REGISTRY='{{ _registry_config }}'
    cd '{{ _module_dir }}'
    cue mod tidy --check
    cue vet ./...
    cue mod publish "{{ version }}" {{ args }}
