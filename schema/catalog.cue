// vim: set ts=2 sw=2 et :
package schema

import mxcschema "github.com/epcim/mxc/schema"

// Catalog of external CRDs vendored for mxc-library's own stacks (as opposed to
// mxc/schema/catalog.cue, which is reserved for schemas the kernel itself needs).
// Consumed by `just schema fetch-crd` (just/schema.just) via this repo's own root.
//
// Each entry's outputDir lands inside the owning stack's own subdirectory
// (AD-016 Self-Contained Modularity -- see mxc-library/stacks/home/homarr/ for
// the established precedent), not a shared mxc-library/schema/ bucket.
catalog: [...mxcschema.#CRDSource | mxcschema.#SchemaSource] & [
	{
		type:      "crd"
		name:      "nbsetupkeys"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0" // pinned per AD-021 -- bump deliberately when re-vendoring
		path:      "config/crd/bases/netbird.io_nbsetupkeys.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		type:      "crd"
		name:      "nbroutingpeers"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0"
		path:      "config/crd/bases/netbird.io_nbroutingpeers.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		type:      "crd"
		name:      "nbresources"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0"
		path:      "config/crd/bases/netbird.io_nbresources.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		type:      "crd"
		name:      "nbgroups"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0"
		path:      "config/crd/bases/netbird.io_nbgroups.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		type:      "crd"
		name:      "nbpolicies"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0"
		path:      "config/crd/bases/netbird.io_nbpolicies.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		type:      "json-schema"
		name:      "cert-manager"
		repo:      "cert-manager/cert-manager"
		ref:       "v1.17.2"
		path:      "deploy/charts/cert-manager/values.schema.json"
		outputDir: "stacks/infra/cert-manager/.chart-schema"
	},
	{
		type:      "helm-values-schema"
		name:      "velero"
		repo:      "vmware-tanzu/helm-charts"
		ref:       "velero-8.2.0"
		path:      "charts/velero/values.yaml"
		outputDir: "stacks/infra/velero/.chart-schema"
	},
	{
		type:      "json-schema"
		name:      "traefik-infra"
		repo:      "traefik/traefik-helm-chart"
		ref:       "v34.2.0"
		path:      "traefik/values.schema.json"
		outputDir: "stacks/infra/traefik/.chart-schema"
	},
	{
		type:      "json-schema"
		name:      "traefik-net"
		repo:      "traefik/traefik-helm-chart"
		ref:       "v34.2.0"
		path:      "traefik/values.schema.json"
		outputDir: "stacks/networking/traefik/.chart-schema"
	},
]
