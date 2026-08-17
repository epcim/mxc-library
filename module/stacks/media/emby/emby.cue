// vim: set ts=2 sw=2 et :
package emby

import "github.com/epcim/mxc/schema"

#Emby: S=schema.#App & {
	_flavor: {
		small: {
			values: controllers: main: containers: main: resources: {
				requests: { cpu: "50m", memory: "256Mi" }
				limits: { cpu: "2", memory: "8Gi" }
			}
		}
	}

	appName:    "emby"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "emby/embyserver"
		tag:        "latest"
	}
	ports: {
		http: {
			port: 8096
		}
	}
	expose: {
		http: {
			target: "ingress"
			annotations: {
				"hajimari.io/enable": "true"
				"hajimari.io/icon": "play-box-multiple"
				"hajimari.io/group": "media"
				"hajimari.io/appName": "Emby"
				"hajimari.io/instance": "svc"
			}
		}
	}
	kustomize: {
		namespace: "media"
		labels: [{
			pairs: app: "emby"
		}]
	}
	values: {
		controllers: main: {
			type: "deployment"
			containers: main: {
				env: {
					TZ:      "Europe/Prague"
					UID:     "1000"
					GID:     "1000"
					GIDLIST: "1000"
					[string]: string
				}
				probes: {
					liveness: {
						enabled: true
						custom:  true
						spec: {
							httpGet: {
								path: "/"
								port: 8096
							}
							initialDelaySeconds: 30
							periodSeconds:       15
							timeoutSeconds:      5
							failureThreshold:    6
						}
					}
					readiness: {
						enabled: true
						custom:  true
						spec: {
							httpGet: {
								path: "/"
								port: 8096
							}
							initialDelaySeconds: 15
							periodSeconds:       10
							timeoutSeconds:      5
							failureThreshold:    12
						}
					}
					startup: {
						enabled: true
						custom:  true
						spec: {
							httpGet: {
								path: "/"
								port: 8096
							}
							initialDelaySeconds: 20
							periodSeconds:       10
							timeoutSeconds:      5
							failureThreshold:    30
						}
					}
				}
			}
		}
		service: main: {
			controller: "main"
			ports: {
				http: port: 8096
			}
		}
	}
	tags: ["media", "emby"]
	flavor: string | *"small"

	_flavor[S.flavor]
}
