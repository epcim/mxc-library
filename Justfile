set shell := ["bash", "-cu"]

mod? schema 'just/schema.just'

GHCR_USER := env_var_or_default("GHCR_USER", "epcim")
OCI_VERSION := env_var_or_default("OCI_VERSION", "v0.1.0")
_module_dir := source_dir() + "/module"
_registry_config := "file:" + source_dir() + "/registry.cue"

[group('oci')]
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
ghcr-login:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -z "${GHCR_PAT:-}" ]]; then
        echo "GHCR_PAT is required; refusing GHCR login" >&2
        exit 1
    fi
    printf '%s' "$GHCR_PAT" | docker login ghcr.io -u "{{ GHCR_USER }}" --password-stdin

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
