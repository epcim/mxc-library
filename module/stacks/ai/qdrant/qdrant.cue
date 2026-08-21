// vim: set ts=2 sw=2 et :
package qdrant

import (
	"github.com/epcim/mxc/schema"
)

#Qdrant: S=schema.#App & {
	_flavor: {
		small: {
			values: resources: {
				requests: {cpu: "100m", memory: "256Mi"}
				limits: {cpu: "1", memory: "1Gi"}
			}
		}
		medium: {
			values: resources: {
				requests: {cpu: "250m", memory: "1Gi"}
				limits: {cpu: "2", memory: "4Gi"}
			}
		}
	}

	appName:      "qdrant"
	appDesc:      "Qdrant vector database for AI similarity search"
	adapter:      "kluctl"
	valuesSchema: string | *"https://raw.githubusercontent.com/qdrant/qdrant-helm/master/charts/qdrant/values.schema.json"

	helmChart: {
		repo:         "https://qdrant.github.io/qdrant-helm"
		chartName:    "qdrant"
		chartVersion: "1.19.0"
		releaseName:  "qdrant"
		namespace:    kustomize.namespace
		skipPrePull:  true
	}

	kustomize: {
		namespace: "llm"
		labels: [{
			pairs: app: "qdrant"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}

	values: {
		image: {
			repository: "qdrant/qdrant"
			tag:        "v1.13.2"
		}
		service: {
			type:     "ClusterIP"
			httpPort: 6333
			grpcPort: 6334
		}
		persistence: {
			enabled:      true
			size:         "10Gi"
			storageClass: "longhorn"
		}
		ingress: {
			enabled:          bool | *true
			ingressClassName: string | *"traefik"
			annotations: {
				"hajimari.io/enable":   "true"
				"hajimari.io/icon":     "database-search"
				"hajimari.io/group":    "infra"
				"hajimari.io/appName":  "Qdrant"
				"hajimari.io/instance": "svc"
				"traefik.ingress.kubernetes.io/router.middlewares": "sys-auth-authelia@kubernetescrd"
				...
			}
			hosts: [
				{
					host: S.appFqdn
					paths: [
						{
							path:        "/"
							pathType:    "Prefix"
							servicePort: 6333
						},
					]
				},
			]
		}
	}

	tags: ["ai", "llm", "vector-db", "qdrant"]
	flavor: string | *"small"

	_flavor[S.flavor]
}
