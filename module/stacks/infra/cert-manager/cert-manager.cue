// vim: set ts=2 sw=2 et :
package cert_manager

import "github.com/epcim/mxc/schema"

#CertManager: schema.#App & {
	appName:    "cert-manager"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://charts.jetstack.io"
		chartName:    "cert-manager"
		chartVersion: "1.17.2"
		releaseName:  "cert-manager"
		namespace:    kustomize.namespace
		skipCRDs:     false
		skipPrePull:  true
	}
	kustomize: {
		namespace: "cert-manager"
		resources: [
			"https://github.com/cert-manager/cert-manager/releases/download/v1.17.2/cert-manager.crds.yaml",
			"helm-rendered.yaml",
		]
	}
	// schema: .chart-schema/values.schema.json
	values: #ValuesSchema & {
		installCRDs: false
		replicaCount: 1
		resources: {
			requests: {
				cpu:    "10m"
				memory: "32Mi"
			}
			limits: {
				memory: "64Mi"
			}
		}
		webhook: {
			replicaCount: 1
			resources: {
				requests: {
					cpu:    "10m"
					memory: "32Mi"
				}
				limits: {
					memory: "64Mi"
				}
			}
		}
		cainjector: {
			replicaCount: 1
			resources: {
				requests: {
					cpu:    "10m"
					memory: "32Mi"
				}
				limits: {
					memory: "128Mi"
				}
			}
		}
	}
	tags: ["infra", "cert-manager"]
}
