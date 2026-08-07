// vim: set ts=2 sw=2 et :
package metallb

import "github.com/epcim/mxc/schema"

#MetalLB: S=schema.#AppCore & {
	_flavor: {
		small: {}
	}

	appName:    "metallb"
	deployment: "kluctl"
	kustomize: {
		namespace: "metallb"
		resources: [
			"https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml",
		]
		labels: [
			{
				includeSelectors: true
				pairs: {
					app: "metallb"
				}
			}
		]
		patches: [
			{
				target: {
					group: "apiextensions.k8s.io"
					kind: "CustomResourceDefinition"
					name: "bgppeers.metallb.io"
				}
				patch: "[{\"op\": \"remove\", \"path\": \"/spec/conversion/webhook/clientConfig/caBundle\"}]"
			}
		]
	}
	
	flavor: string | *"small"
	
	values: {
		l2advertisement: {
			[string]: {
				ipAddressPools: [...string]
				interfaces?: [...string]
			}
		}
		ipaddresspool: {
			[string]: [...string]
		}
	}
	tags: ["infra", "metallb"]
	
	_flavor[S.flavor]
}
