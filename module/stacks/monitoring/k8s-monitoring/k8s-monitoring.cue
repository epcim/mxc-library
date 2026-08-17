// vim: set ts=2 sw=2 et :
package k8s_monitoring

import (
	"github.com/epcim/mxc/schema"
	_loki "github.com/epcim/mxc-library/stacks/monitoring/loki"
	_mimir "github.com/epcim/mxc-library/stacks/monitoring/mimir"
	_grafana "github.com/epcim/mxc-library/stacks/monitoring/grafana"
)

// Cross-app context reference example: instance names/labelSelectors derive
// from #Loki/#Mimir/#Grafana's own appName instead of duplicating hardcoded
// strings that could drift if those apps are ever renamed.
#K8sMonitoring: schema.#App & {
	appName:    "k8s-monitoring"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://grafana.github.io/helm-charts"
		chartName:    "k8s-monitoring"
		chartVersion: "2.0.42"
		releaseName:  "k8s-monitoring"
		namespace:    kustomize.namespace
		skipPrePull:  true
	}
	kustomize: {
		namespace: "k8s-monitor"
		resources: [
			"helm-rendered.yaml",
		]
	}
	// schema: https://github.com/grafana/helm-charts/blob/k8s-monitoring-2.0.42/charts/k8s-monitoring/values.yaml (values.schema.json presence not yet verified)
	values: {
		cluster: {
			name: "{{ args.env }}"
		}
		annotationAutodiscovery: {
			enabled: true
		}
		"alloy-metrics": {
			enabled: true
		}
		"alloy-logs": {
			enabled: true
		}
		"alloy-singleton": {
			enabled: true
		}
		clusterEvents: {
			enabled: true
		}
		clusterMetrics: {
			enabled: true
		}
		nodeLogs: {
			journal: {
				units: [
					"kubelet.service",
					"containerd.service",
				]
			}
		}
		podLogs: {
			enabled: true
		}
		integrations: {
			alloy: instances: [
				{
					name: "alloy-metrics"
					labelSelectors: "app.kubernetes.io/name": "alloy-metrics"
				},
				{
					name: "alloy-logs"
					labelSelectors: "app.kubernetes.io/name": "alloy-logs"
				},
				{
					name: "alloy-singleton"
					labelSelectors: "app.kubernetes.io/name": "alloy-singleton"
				},
			]
			etcd: instances: [{
				name: "k8s-controlplane-etcd"
				labelSelectors: "app.kubernetes.io/component": "etcd"
			}]
			loki: instances: [{
				name: _loki.#Loki.appName
				labelSelectors: "app.kubernetes.io/name": _loki.#Loki.appName
			}]
			mimir: instances: [{
				name: _mimir.#Mimir.appName
				labelSelectors: "app.kubernetes.io/name": _mimir.#Mimir.appName
			}]
			grafana: instances: [{
				name: _grafana.#Grafana.appName
				labelSelectors: "app.kubernetes.io/name": _grafana.#Grafana.appName
			}]
		}
		destinations: [{
			name:     "hostedPrometheus"
			type:     "prometheus"
			url:      "http://mimir-nginx.\(_mimir.#Mimir.kustomize.namespace).svc:80/api/v1/push"
			tenantId: "anonymous"
			headers: {
				"X-Scope-OrgID": "anonymous"
			}
		}, {
			name:     "hostedLoki"
			type:     "loki"
			url:      "http://loki-gateway.\(_loki.#Loki.kustomize.namespace).svc:80/loki/api/v1/push"
			tenantId: "anonymous"
			headers: {
				"X-Scope-OrgID": "anonymous"
			}
		}]
	}
	tags: ["monitoring", "alloy"]
}
