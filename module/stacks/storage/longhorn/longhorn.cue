// vim: set ts=2 sw=2 et :
package longhorn

import "github.com/epcim/mxc/schema"

#Longhorn: S=schema.#App & {
	_flavor: {
		small: {}
	}

	appName:    "longhorn"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://charts.longhorn.io"
		chartName:    "longhorn"
		chartVersion: "1.8.0"
		releaseName:  "longhorn"
		namespace:    "longhorn-system"
		skipCRDs:     false
		skipPrePull:  true
	}
	kustomize: {
		namespace: "longhorn-system"
		labels: [{
			pairs: app: "longhorn"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	
	flavor: string | *"small"

	// schema: https://github.com/longhorn/charts (chart "longhorn" v1.8.0, master branch, path charts/longhorn) -- values.schema.json presence not yet verified, see AGENTS-TODO.md
	values: {
		csi: {
			kubeletRootDir: "/var/snap/microk8s/common/var/lib/kubelet"
		}
		preUpgradeChecker: {
			jobEnabled:          false
			upgradeVersionCheck: false
		}
	}
	tags: ["storage", "longhorn"]
	
	_flavor[S.flavor]
}
