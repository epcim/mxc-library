// vim: set ts=2 sw=2 et :
package monitoring

import "github.com/epcim/mxc/schema"

#Mimir: schema.#AppCore & {
	appName:    "mimir"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://grafana.github.io/helm-charts"
		chartName:    "mimir-distributed"
		chartVersion: "5.5.1"
		releaseName:  "mimir"
		namespace:    kustomize.namespace
		skipPrePull:  true
	}
	kustomize: {
		namespace: "env-monitor-mimir"
		labels: [{
			pairs: app: "mimir"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	// schema: https://github.com/grafana/helm-charts/blob/mimir-distributed-5.5.1/charts/mimir-distributed/values.yaml (values.schema.json presence not yet verified)
	context: {
		mimir: {
			structuredConfig: {
				ingester: {
					ring: {
						replication_factor: 1
					}
				}
				limits: {
					max_global_series_per_user: 0
					ingestion_rate:             100000
					ingestion_burst_size:       200000
				}
			}
		}
		minio: {
			enabled: true
		}
		compactor: {
			replicas: *1 | int
			persistentVolume: {
				enabled: true
				size:    "5Gi"
				storageClass?: string
			}
		}
		ingester: {
			replicas: *1 | int
			persistentVolume: {
				enabled: true
				size:    "5Gi"
				storageClass?: string
			}
		}
		store_gateway: {
			replicas: *1 | int
			persistentVolume: {
				enabled: true
				size:    "5Gi"
				storageClass?: string
			}
		}
		distributor: {
			replicas: *1 | int
		}
		querier: {
			replicas: *1 | int
		}
		query_frontend: {
			replicas: *1 | int
		}
		nginx: {
			enabled:  true
			replicas: *1 | int
		}
	}
	tags: ["monitoring", "mimir"]
}
