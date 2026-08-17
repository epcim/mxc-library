// vim: set ts=2 sw=2 et :
package woodpecker

import "github.com/epcim/mxc/schema"

#Woodpecker: S=schema.#App & {
	_flavor: {
		nano: {
			values: {
				server: resources: {
					limits: { cpu: "300m", memory: "256Mi" }
					requests: { cpu: "100m", memory: "128Mi" }
				}
				agent: {
					replicaCount: 1
					resources: {
						limits: { cpu: "500m", memory: "256Mi" }
						requests: { cpu: "100m", memory: "128Mi" }
					}
				}
			}
		}
		small: {
			values: {
				server: resources: {
					limits: { cpu: "500m", memory: "512Mi" }
					requests: { cpu: "200m", memory: "256Mi" }
				}
				agent: {
					replicaCount: 2
					resources: {
						limits: { cpu: "1", memory: "512Mi" }
						requests: { cpu: "200m", memory: "256Mi" }
					}
				}
			}
		}
		medium: {
			values: {
				server: resources: {
					limits: { cpu: "1", memory: "1Gi" }
					requests: { cpu: "300m", memory: "512Mi" }
				}
				agent: {
					replicaCount: 3
					resources: {
						limits: { cpu: "2", memory: "1Gi" }
						requests: { cpu: "500m", memory: "512Mi" }
					}
				}
			}
		}
		large: {
			values: {
				server: resources: {
					limits: { cpu: "2", memory: "2Gi" }
					requests: { cpu: "500m", memory: "1Gi" }
				}
				agent: {
					replicaCount: 4
					resources: {
						limits: { cpu: "4", memory: "2Gi" }
						requests: { cpu: "1", memory: "1Gi" }
					}
				}
			}
		}
	}

	appName:    "woodpecker"
	deployment: "kluctl"
	helmChart: {
		repo:         "oci://ghcr.io/woodpecker-ci/helm/woodpecker"
		chartVersion: "2.1.0"
		releaseName:  "woodpecker"
		namespace:    kustomize.namespace
		skipCRDs:     false
		skipPrePull:  true
	}
	image: {
		repository: "woodpeckerci/woodpecker-server"
		tag:        "latest"
	}
	kustomize: {
		namespace: "gitops"
		labels: [{
			pairs: app: "woodpecker"
		}]
		resources: [
			"helm-rendered.yaml"
		]
	}
	
	flavor: string | *"small"

	// schema: https://github.com/woodpecker-ci/helm/blob/main/charts/woodpecker/values.yaml (repo doesn't tag per-chart releases like the grafana/velero monorepos; pin an exact ref for v2.1.0 when vendoring)
	values: {
		server: {
			hostAliases?: [...{ip: string, hostnames: [...string]}]
			podSecurityContext: {
				fsGroup: 1000
				fsGroupChangePolicy: "OnRootMismatch"
			}
			securityContext: {
				runAsUser: 1000
				runAsGroup: 1000
			}
			env: {
				WOODPECKER_HOST?:  string
				WOODPECKER_ADMIN?: string
				SMTP_HOST:         "{{ secrets.infra.notifications.host }}"
				SMTP_PORT:         "{{ secrets.infra.notifications.port }}"
				SMTP_USER:         "{{ secrets.infra.notifications.user }}"
				SMTP_PASS:         "{{ secrets.infra.notifications.pass }}"
				SMTP_FROM:         "{{ secrets.infra.notifications.addr }}"
				[string]:          string
			}
			ingress: {
				enabled:          true
				ingressClassName: "zone-service-traefik"
				annotations: {
					"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
					"traefik.ingress.kubernetes.io/router.tls":         "true"
					"traefik.ingress.kubernetes.io/router.tls.certresolver": "cloudflare"
					"traefik.ingress.kubernetes.io/router.middlewares": "sys-auth-authelia@kubernetescrd"
					"hajimari.io/enable":                                "true"
					"hajimari.io/icon":                                  "pipe"
					"hajimari.io/group":                                 "cicd"
					"hajimari.io/appName":                               "woodpecker"
					"hajimari.io/instance":                              "int"
				}
				hosts: [{
					host: string
					paths: [{
						path:     "/"
						pathType: "Prefix"
					}]
				}]
				tls: [{
					hosts: [...string]
				}]
			}
		}
		agent: {
			replicaCount: int | *2
			podSecurityContext: {
				fsGroup: 1000
				fsGroupChangePolicy: "OnRootMismatch"
			}
			securityContext: {
				runAsUser: 1000
				runAsGroup: 1000
			}
			env: {
				WOODPECKER_AGENT_CONFIG_FILE: "/etc/woodpecker/agent.conf"
				[string]:                     string
			}
		}
	}
	tags: ["cicd", "woodpecker"]
	
	_flavor[S.flavor]
}
