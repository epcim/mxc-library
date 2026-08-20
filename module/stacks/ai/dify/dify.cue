// vim: set ts=2 sw=2 et :
package dify

import (
	"github.com/epcim/mxc/schema"
)

#Dify: S=schema.#App & {
	_flavor: {
		small: {
			values: api: resources: {
				requests: {cpu: "200m", memory: "512Mi"}
				limits: {cpu: "1", memory: "1Gi"}
			}
		}
		medium: {
			values: api: resources: {
				requests: {cpu: "500m", memory: "1Gi"}
				limits: {cpu: "2", memory: "2Gi"}
			}
		}
	}

	appName:      "dify"
	appDesc:      "Dify LLM Application Development Platform and Visual Workflow Orchestrator"
	adapter:      "kluctl"
	valuesSchema: string | *"https://raw.githubusercontent.com/langgenius/dify-helm/main/charts/dify/values.schema.json"

	helmChart: {
		repo:         "https://langgenius.github.io/dify-helm"
		chartName:    "dify"
		chartVersion: "0.4.0"
		releaseName:  "dify"
		namespace:    kustomize.namespace
	}

	kustomize: {
		namespace: "llm"
		labels: [{
			pairs: app: "dify"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}

	secrets: {
		secret_key?: string
	}

	values: {
		global: {
			host:      [if S.appFqdn != _|_ {S.appFqdn}, "dify.apealive.net"][0]
			enableTLS: false
		}
		extraBackendEnvs: [
			if secrets.secret_key != _|_ {
				name:  "SECRET_KEY"
				value: secrets.secret_key
			},
			{
				name:  "LOG_LEVEL"
				value: "INFO"
			},
		]
		ingress: {
			enabled:          bool | *true
			ingressClassName: string | *"traefik"
			annotations: {
				"hajimari.io/enable":   "true"
				"hajimari.io/icon":     "sitemap"
				"hajimari.io/group":    "infra"
				"hajimari.io/appName":  "Dify"
				"hajimari.io/instance": "svc"
				"traefik.ingress.kubernetes.io/router.middlewares": "sys-auth-authelia@kubernetescrd"
				...
			}
			hosts: [
				{
					host: [if S.appFqdn != _|_ {S.appFqdn}, "dify.apealive.net"][0]
					paths: [
						{
							path:     "/"
							pathType: "Prefix"
						},
					]
				},
			]
		}
	}

	tags: ["ai", "llm", "agent", "dify"]
	flavor: string | *"small"

	_flavor[S.flavor]
}
