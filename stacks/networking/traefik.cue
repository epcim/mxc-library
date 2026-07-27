// vim: set ts=2 sw=2 et :
package networking

import "github.com/epcim/mxc/schema"

#TraefikSvc: S=schema.#AppCore & {
	_flavor: {
		nano: {
			context: resources: {
				limits: { cpu: "300m", memory: "256Mi" }
				requests: { cpu: "20m", memory: "100Mi" }
			}
		}
		small: {
			context: resources: {
				limits: { cpu: "500m", memory: "512Mi" }
				requests: { cpu: "200m", memory: "256Mi" }
			}
		}
		medium: {
			context: resources: {
				limits: { cpu: "1", memory: "1Gi" }
				requests: { cpu: "300m", memory: "512Mi" }
			}
		}
		large: {
			context: resources: {
				limits: { cpu: "2", memory: "2Gi" }
				requests: { cpu: "500m", memory: "1Gi" }
			}
		}
		custom: {}
	}

	appName:    "traefik-svc"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://traefik.github.io/charts"
		chartName:    "traefik"
		chartVersion: "34.2.0"
		releaseName:  string | *"traefik"
		namespace:    kustomize.namespace
		skipCRDs:     false
		skipPrePull:  true
	}
	kustomize: {
		namespace: "zone-service"
		resources: [
			"helm-rendered.yaml",
			"overlays/traefik/cloudflare-api.yml",
		]
	}

	flavor: string | *"small"

	// schema: https://github.com/traefik/traefik-helm-chart/blob/v34.2.0/traefik/values.schema.json
	context: {
		fullnameOverride: "traefik"
		installCRDs:      false
		ingressClass: {
			enabled:        true
			isDefaultClass: false
			name:           "zone-service-traefik"
		}
		providers: kubernetesIngress: {
			ingressClass: "zone-service-traefik"
			namespaces: [
				"zone-service",
				"home",
				"media",
				"productivity",
				"game",
				"maker",
				"iot",
				"gitops",
			]
		}
		globalArguments?: [...string]
		service?: {
			annotations?: [string]: string
			loadBalancerSourceRanges?: [...string]
			spec?: loadBalancerIP?: string
			additionalServices?: [string]: {
				annotations?: [string]: string
				spec?: {
					type:            string
					loadBalancerIP?: string
				}
			}
		}
		persistence?: {
			storageClass?: string
		}
		tlsOptions: {}
		ports: {
			ssh?: {
				port?:        int
				exposedPort?: int
				expose?: default?: bool
			}
			metrics?: {
				port:        int | *8082
				exposedPort: int | *8082
				expose: default: bool | *true
			}
			traefik?: {
				expose?: default?: bool
			}
			web: {
				expose?: [string]: bool
				redirections?: entryPoint?: {
					to?:        string
					scheme?:    string
					permanent?: bool
				}
			}
			websecure: {
				expose?: [string]: bool
				tls?: {
					enabled?:      bool
					certResolver?: string
					domains?: [...{
						main:  string
						sans?: [...string]
					}]
				}
			}
		}
		certificatesResolvers: cloudflare: acme: {
			email:        string
			caServer:     "https://acme-v02.api.letsencrypt.org/directory"
			storage:      "/data/acme.json"
			dnsChallenge: {
				provider:  "cloudflare"
				resolvers: "1.1.1.1"
			}
		}
		env?: [...{
			name?:      string
			value?:     string
			valueFrom?: {[string]: _}
		}]
	}
	tags: ["networking", "traefik-svc"]

	_flavor[S.flavor]
}
