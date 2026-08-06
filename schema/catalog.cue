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
catalog: [...mxcschema.#CRDSource] & [
	{
		name:      "nbsetupkeys"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0" // pinned per AD-021 -- bump deliberately when re-vendoring
		path:      "config/crd/bases/netbird.io_nbsetupkeys.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		name:      "nbroutingpeers"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0"
		path:      "config/crd/bases/netbird.io_nbroutingpeers.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		name:      "nbresources"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0"
		path:      "config/crd/bases/netbird.io_nbresources.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		name:      "nbgroups"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0"
		path:      "config/crd/bases/netbird.io_nbgroups.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
	{
		name:      "nbpolicies"
		repo:      "netbirdio/kubernetes-operator"
		ref:       "v0.8.0"
		path:      "config/crd/bases/netbird.io_nbpolicies.yaml"
		outputDir: "stacks/networking/netbird/schema"
	},
]
