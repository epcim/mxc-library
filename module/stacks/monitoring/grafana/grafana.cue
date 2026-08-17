// vim: set ts=2 sw=2 et :
package grafana

import (
	"github.com/epcim/mxc/schema"
	_mimir "github.com/epcim/mxc-library/stacks/monitoring/mimir"
	_loki "github.com/epcim/mxc-library/stacks/monitoring/loki"
)

// Cross-app context reference example: the default datasources point at
// #Mimir/#Loki's own kustomize.namespace instead of duplicating a hardcoded
// hostname — if either app's namespace ever changes, this stays correct.
#Grafana: S=schema.#App & {
	_flavor: {
		small: {
			values: resources: {
				requests: {cpu: "50m", memory: "128Mi"}
				limits: {memory: "512Mi"}
			}
		}
	}

	appName:    "grafana"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://grafana.github.io/helm-charts"
		chartName:    "grafana"
		chartVersion: "8.8.2"
		releaseName:  "grafana"
		namespace:    kustomize.namespace
		skipPrePull:  true
	}
	image: {
		repository: "grafana/grafana"
		tag:        "latest"
	}
	kustomize: {
		namespace: "env-monitor"
		labels: [{
			pairs: app: "grafana"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	// schema: https://github.com/grafana/helm-charts/blob/grafana-8.8.2/charts/grafana/values.yaml (values.schema.json presence not yet verified)
	values: {
		persistence: {
			enabled: true
			type:    "pvc"
			size:    "5Gi"
			storageClassName?: string
		}
		adminUser: "admin"
		admin: {
			existingSecret: "grafana-admin"
			userKey:        "admin-user"
			passwordKey:    "admin-password"
		}
		"grafana.ini": {
			"auth.proxy": {
				enabled:            true
				header_name:        "Remote-User"
				header_property:    "username"
				auto_sign_up:       true
				headers:            "Email:Remote-Email Groups:Remote-Groups"
				enable_login_token: true
			}
			users: {
				auto_assign_org_role: "Viewer"
			}
			auth: {
				role_attribute_path: "contains(groups[*], 'admins') && 'Admin' || contains(groups[*], 'editors') && 'Editor' || 'Viewer'"
			}
		}
		sidecar: {
			dashboards: {
				enabled:         true
				label:           "grafana_dashboard"
				labelValue:      "1"
				searchNamespace: "ALL"
			}
			datasources: {
				enabled:    true
				label:      "grafana_datasource"
				labelValue: "1"
			}
		}
		datasources: {
			"datasources.yaml": {
				apiVersion: 1
				datasources: [{
					name:      "Mimir"
					type:      "prometheus"
					url:       "http://mimir-nginx.\(_mimir.#Mimir.kustomize.namespace).svc:80/prometheus"
					access:    "proxy"
					isDefault: true
				}, {
					name:   "Loki"
					type:   "loki"
					url:    "http://loki-gateway.\(_loki.#Loki.kustomize.namespace).svc:80"
					access: "proxy"
				}]
			}
		}
	}
	tags: ["monitoring", "grafana"]
	flavor: string | *"small"

	_flavor[S.flavor]
}
