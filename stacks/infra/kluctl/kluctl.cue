// vim: set ts=2 sw=2 et :
package kluctl

import "github.com/epcim/mxc/schema"

#KluctlController: S=schema.#AppCore & {
	appName:    "kluctl-controller"
	deployment: "kluctl"
	image: {
		repository: "github.com/kluctl/kluctl"
		tag:        "v2.26.0"
	}
	kustomize: {
		namespace: "kluctl-system"
	}
	
	flavor: string | *"medium"
	
	tags: ["infra", "kluctl"]
	
	values: controller_resources: schema.#ResourcePresets[S.flavor]
}
