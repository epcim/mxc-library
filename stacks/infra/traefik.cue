// vim: set ts=2 sw=2 et :
package infra

import "github.com/epcim/mxc/schema"

#Traefik: S=schema.#AppCore & {
	_flavor: {
		nano: {
			context: resources: {
				limits: { cpu: "300m", memory: "256Mi" }
				requests: { cpu: "100m", memory: "128Mi" }
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

	appName:    "traefik"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://traefik.github.io/charts"
		chartName:    "traefik"
		chartVersion: "34.2.0"
		releaseName:  string | *"traefik"
		namespace:    kustomize.namespace
		skipCRDs:     true
		skipPrePull:  true
	}
	kustomize: {
		namespace: string | *"sys"
		resources: [...string] | *[
			"helm-rendered.yaml",
			"overlays/traefik/cloudflare-api.yml",
		]
	}
	
	flavor: string | *"small"

	// schema: https://github.com/traefik/traefik-helm-chart/blob/v34.2.0/traefik/values.schema.json
	context: {
		globalArguments?: [...string]
		service: {
			loadBalancerSourceRanges: [...string] | *[
				"172.31.0.0/12",
				"192.168.0.0/16",
				"10.0.0.0/8",
			]
			spec?: {
				loadBalancerIP?: string
			}
		}
		persistence?: {
			storageClass?: string
		}
		ports: {
			ssh: {
				port:        int | *8222
				exposedPort: int | *22
				expose: default: bool | *true
			}
			metrics: {
				port:        int | *8082
				exposedPort: int | *8082
				expose: default: bool | *true
			}
			traefik: {
				expose: default: bool | *true
			}
			web: {
				expose?: {
					default?: bool
					int?:     bool
				}
				redirections: entryPoint: {
					to:        string | *"websecure"
					scheme:    string | *"https"
					permanent: bool | *true
				}
			}
			websecure: {
				expose: {
					default: bool | *true
				}
				tls: {
					enabled?: bool | *true
					certResolver: string | *"cloudflare"
					domains: [..._] | *[
						{
							main: "{{ args.domain }}"
							sans: [
								"*.{{ args.domain }}",
							]
						}
					]
				}
			}
		}
		certificatesResolvers: {
			cloudflare: {
				acme: {
					email: string | *"{{ secrets.infra.admin.email }}"
					caServer: string | *"https://acme-v02.api.letsencrypt.org/directory"
					dnsChallenge: {
						provider: string | *"cloudflare"
						resolvers: string | *"1.1.1.1"
					}
					storage: string | *"/data/acme.json"
				}
			}
		}
		env: [...{name: string, value?: string, valueFrom?: _}] | *[
			{
				name: "CF_API_EMAIL"
				value: "{{ secrets.infra.admin.email }}"
			},
			{
				name: "CF_DNS_API_TOKEN"
				valueFrom: secretKeyRef: {
					name: "cloudflare-api"
					key: "{{ args.domain }}"
				}
			}
		]
	}
	tags: ["infra", "traefik"]
	
	_flavor[S.flavor]
}
