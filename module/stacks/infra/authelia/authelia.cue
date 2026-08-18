// vim: set ts=2 sw=2 et :
package authelia

import "github.com/epcim/mxc/schema"

#Authelia: S=schema.#App & {
	appName:    "authelia"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "ghcr.io/authelia/authelia"
		tag:        "4.38.19"
	}
	ports: {
		http: {
			port: 9091
		}
	}
	// Ingress is hand-rolled below (context.ingress.main) because it needs
	// Authelia-specific annotations/hosts the generic #Projection can't express
	// under this key; target stays "none" so #Projection does not also emit a
	// second, duplicate ingress.http. context.ingress.main's host/tls derive
	// from S.appFqdn (set at the cluster override site) instead of a
	// second hardcoded literal, so there's one source of truth for the hostname.
	expose: {
		http: {
			target: "none"
		}
	}
	kustomize: {
		namespace: "sys"
		labels: [{
			pairs: app: "authelia"
		}]
		resources: [
			"helm-rendered.yaml",
			"./overlays/authelia/config.yml",
			"./overlays/traefik/middleware-authelia.yml",
		]
	}

	values: {
		controllers: main: {
			containers: main: {
				image: {
					repository: S.image.repository
					tag:        S.image.tag
				}
				env: {
					TZ:                                   "Europe/Prague"
					AUTHELIA_JWT_SECRET_FILE:             "/secrets/JWT_SECRET"
					AUTHELIA_SESSION_SECRET_FILE:         "/secrets/SESSION_SECRET"
					AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE: "/secrets/STORAGE_ENCRYPTION_KEY"
					X_AUTHELIA_CONFIG:                    "/config/configuration.yml"
				}
				resources: {
					requests: {
						cpu:    "50m"
						memory: "64Mi"
					}
					limits: {
						memory: "256Mi"
					}
				}
				probes: {
					liveness: enabled: true
					readiness: enabled: true
					startup: {
						enabled: true
						spec: {
							initialDelaySeconds: 10
							periodSeconds:        5
							failureThreshold:     30
						}
					}
				}
			}
		}
		service: main: {
			controller: "main"
			ports: http: port: 9091
		}
		ingress: main: {
			annotations: {
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
				"traefik.ingress.kubernetes.io/router.tls":         "true"
				"hajimari.io/enable":                               "true"
				"hajimari.io/icon":                                 "shield-account"
				"hajimari.io/group":                                "security"
				"hajimari.io/appName":                              "Authelia"
				"hajimari.io/instance":                             "main"
			}
			let effectiveFqdn = [if S.appFqdn != _|_ { S.appFqdn }, if S.expose.http.fqdn != _|_ { S.expose.http.fqdn }, "auth.example.com"][0]
			hosts: [{
				host: effectiveFqdn
				paths: [{
					path:     "/"
					pathType: "Prefix"
					service: {
						identifier: "main"
						port:       "http"
					}
				}]
			}]
			tls: [{
				hosts: [
					effectiveFqdn,
				]
			}]
		}
		persistence: {
			config: {
				type: "configMap"
				name: "authelia-config"
				globalMounts: [{
					path:     "/config"
					readOnly: true
				}]
			}
			secrets: {
				type: "secret"
				name: "authelia-secrets"
				globalMounts: [{
					path:     "/secrets"
					readOnly: true
				}]
			}
			data: {
				existingClaim: "authelia-data"
				globalMounts: [{
					path: "/data"
				}]
			}
		}
	}

	overlays: {
		pvc: [{
			name:         "authelia-data"
			size:         "1Gi"
			storageClass: "longhorn"
		}]
		middleware_authelia: {
			namespace: "sys"
		}
	}

	tags: ["infra", "security", "authelia"]
}
