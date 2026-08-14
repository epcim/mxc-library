// vim: set ts=2 sw=2 et :
package loki

import "github.com/epcim/mxc/schema"

#Loki: schema.#AppCore & {
	appName:    "loki"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://grafana.github.io/helm-charts"
		chartName:    "loki"
		chartVersion: "6.6.2"
		releaseName:  "loki"
		namespace:    kustomize.namespace
		skipPrePull:  true
	}
	kustomize: {
		namespace: "env-monitor-loki"
		labels: [{
			pairs: app: "loki"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	// schema: https://github.com/grafana/helm-charts/blob/helm-loki-6.6.2/charts/loki/values.yaml (repo tags this chart "helm-loki-*", not "loki-*"; values.schema.json presence not yet verified)
	values: {
		deploymentMode: "SingleBinary"
		loki: {
			auth_enabled: false
			commonConfig: {
				replication_factor: 1
			}
			schemaConfig: {
				configs: [{
					from:         "2024-01-01"
					store:        "tsdb"
					object_store: "filesystem"
					schema:       "v13"
					index: {
						prefix: "loki_index_"
						period: "24h"
					}
				}]
			}
			storage: {
				type: "filesystem"
			}
		}
		singleBinary: {
			replicas: *1 | int
			persistence: {
				enabled: true
				size:    "10Gi"
				storageClass?: string
			}
			resources: {
				requests: {cpu: "10m", memory: "128Mi"}
				limits: {cpu: "200m", memory: "512Mi"}
			}
		}
		gateway: {
			enabled:  true
			replicas: *1 | int
		}
		read: {
			replicas: 0
		}
		write: {
			replicas: 0
		}
		backend: {
			replicas: 0
		}
	}
	tags: ["monitoring", "loki"]
}
