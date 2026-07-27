// vim: set ts=2 sw=2 et :
package cicd

import "github.com/epcim/mxc/schema"

#Harbor: S=schema.#AppCore & {
	_flavor: {
		nano: {
			context: {
				core: resources: {
					limits: { cpu: "300m", memory: "256Mi" }
					requests: { cpu: "10m", memory: "128Mi" }
				}
				jobservice: resources: {
					limits: { cpu: "100m", memory: "128Mi" }
					requests: { cpu: "10m", memory: "64Mi" }
				}
				registry: resources: {
					limits: { cpu: "200m", memory: "256Mi" }
					requests: { cpu: "10m", memory: "128Mi" }
				}
			}
		}
		small: {
			context: {
				core: resources: {
					limits: { cpu: "500m", memory: "512Mi" }
					requests: { cpu: "200m", memory: "256Mi" }
				}
				jobservice: resources: {
					limits: { cpu: "300m", memory: "256Mi" }
					requests: { cpu: "100m", memory: "128Mi" }
				}
				registry: resources: {
					limits: { cpu: "300m", memory: "512Mi" }
					requests: { cpu: "100m", memory: "256Mi" }
				}
			}
		}
		medium: {
			context: {
				core: resources: {
					limits: { cpu: "1", memory: "1Gi" }
					requests: { cpu: "300m", memory: "512Mi" }
				}
				jobservice: resources: {
					limits: { cpu: "500m", memory: "512Mi" }
					requests: { cpu: "200m", memory: "256Mi" }
				}
				registry: resources: {
					limits: { cpu: "500m", memory: "1Gi" }
					requests: { cpu: "200m", memory: "512Mi" }
				}
			}
		}
		large: {
			context: {
				core: resources: {
					limits: { cpu: "2", memory: "2Gi" }
					requests: { cpu: "500m", memory: "1Gi" }
				}
				jobservice: resources: {
					limits: { cpu: "1", memory: "1Gi" }
					requests: { cpu: "300m", memory: "512Mi" }
				}
				registry: resources: {
					limits: { cpu: "1", memory: "2Gi" }
					requests: { cpu: "300m", memory: "1Gi" }
				}
			}
		}
	}

	appName:    "harbor"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://helm.goharbor.io"
		chartName:    "harbor"
		chartVersion: "1.18.2"
		releaseName:  "harbor"
		namespace:    kustomize.namespace
		skipCRDs:     false
		skipPrePull:  true
	}
	image: {
		repository: "goharbor/harbor-core"
		tag:        "latest"
	}
	kustomize: {
		namespace: "gitops"
		labels: [{
			pairs: app: "harbor"
		}]
		resources: [
			"helm-rendered.yaml"
		]
	}
	
	flavor: string | *"small"

	// schema: https://github.com/goharbor/harbor-helm/blob/v1.18.2/values.yaml (no values.schema.json published upstream)
	context: {
		expose: {
			type: "ingress"
			tls: {
				enabled:    true
				certSource: "none"
			}
			ingress: {
				hosts: {
					core: string
				}
				className: "zone-service-traefik"
				annotations: {
					"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
					"traefik.ingress.kubernetes.io/router.tls":         "true"
					"traefik.ingress.kubernetes.io/router.middlewares": "sys-auth-authelia@kubernetescrd"
					"hajimari.io/enable":                                "true"
					"hajimari.io/icon":                                  "docker"
					"hajimari.io/group":                                 "cicd"
					"hajimari.io/appName":                               "Harbor"
					"hajimari.io/instance":                              "int"
				}
			}
		}
		// Derived from expose.ingress.hosts.core so callers only ever set one
		// hostname; avoids the two values drifting apart across cluster overrides.
		externalURL: "https://\(expose.ingress.hosts.core)"
		smtp: {
			host:     "{{ secrets.infra.notifications.host }}"
			port:     "{{ secrets.infra.notifications.port }}"
			username: "{{ secrets.infra.notifications.user }}"
			password: "{{ secrets.infra.notifications.pass }}"
			from:     "{{ secrets.infra.notifications.addr }}"
		}
		persistence: {
			enabled: true
			persistentVolumeClaim: {
				registry: {
					storageClass: string
					size:         string | *"50Gi"
				}
				jobservice: {
					jobLog: {
						storageClass: string
						size:         "1Gi"
					}
				}
				database: {
					storageClass: string
					size:         "5Gi"
				}
				redis: {
					storageClass: string
					size:         "1Gi"
				}
				trivy: {
					storageClass: string
					size:         "5Gi"
				}
			}
		}
		harborAdminPassword: "Harbor_Default_Password_Placeholder_To_Be_Overridden"
		secretKey:           "Harbor_Default_Secret_Key_Placeholder_To_Be_Overridden"
		database: {
			type: "internal"
		}
		redis: {
			type: "internal"
		}
		trivy: {
			enabled: true
		}
		metrics: {
			enabled: true
		}
	}
	tags: ["cicd", "harbor"]
	
	_flavor[S.flavor]
}
