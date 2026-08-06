// vim: set ts=2 sw=2 et :
package media

import "github.com/epcim/mxc/schema"

#Silo: schema.#AppCore & {
	appName:    string | *"silo"
	deployment: string | *"kluctl"
	contextSchema: "#app-template"
	image: {
		repository: "ghcr.io/silo-server/silo-server"
		tag:        "latest"
	}
	ports: {
		http: {
			port: 8080
		}
	}
	expose: {
		http: {
			target: "ingress"
			annotations: {
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
				"traefik.ingress.kubernetes.io/router.tls": "true"
				"traefik.ingress.kubernetes.io/router.tls.certresolver": "cloudflare"
				"hajimari.io/enable": "true"
				"hajimari.io/icon": "server-network"
				"hajimari.io/group": "media"
				"hajimari.io/appName": "Silo"
				"hajimari.io/instance": "svc"
			}
		}
	}
	storage: {
		"silo-data": {
			size:  string | *"5Gi"
			class: string | *"longhorn"
		}
		"redis-data": {
			size:  string | *"1Gi"
			class: string | *"longhorn"
		}
	}
	secrets: {
		secretKey: string | *"{{ secrets.silo.secretKey }}"
		notifications: {
			host: string | *"{{ secrets.silo.notifications.host }}"
			port: string | *"{{ secrets.silo.notifications.port }}"
			user: string | *"{{ secrets.silo.notifications.user }}"
			pass: string | *"{{ secrets.silo.notifications.pass }}"
			addr: string | *"{{ secrets.silo.notifications.addr }}"
		}
	}
	tags: ["media", "silo"]
	kustomize: {
		namespace: "media"
		labels: [{
			pairs: app: "silo"
		}]
	}
	context: {
		controllers: main: {
			type: "deployment"
			initContainers: {
				"init-redis-permissions": {
					image: {
						repository: "busybox"
						tag:        "latest"
					}
					command: ["sh", "-c", "chown -R 999:999 /data"]
					securityContext: runAsUser: 0
				}
			}
			containers: {
				main: {
					image: {
						repository: "ghcr.io/silo-server/silo-server"
						tag:        "latest"
					}
					env: {
						TZ:                    "Europe/Prague"
						SMTP_HOST:             secrets.notifications.host
						SMTP_PORT:             secrets.notifications.port
						SMTP_USER:             secrets.notifications.user
						SMTP_PASS:             secrets.notifications.pass
						SMTP_FROM:             secrets.notifications.addr
						MODE:                  "integrated"
						SECRET_KEY:            secrets.secretKey
						DATABASE_URL:          "postgres://silo:silo@localhost:5432/silo?sslmode=disable"
						REDIS_URL:             "redis://localhost:6379"
						SILO_PLUGIN_CACHE_DIR: "/var/lib/silo/plugins"
					}
					resources: {
						requests: {cpu: "100m", memory: "256Mi"}
						limits: {memory: "1Gi"}
					}
					probes: {
						liveness: {
							enabled: true
							custom:  true
							spec: {
								httpGet: {
									path: "/api/v1/health"
									port: 8080
								}
								initialDelaySeconds: 30
								periodSeconds:        20
								timeoutSeconds:       5
								failureThreshold:     6
							}
						}
						readiness: {
							enabled: true
							custom:  true
							spec: {
								httpGet: {
									path: "/api/v1/ready"
									port: 8080
								}
								initialDelaySeconds: 20
								periodSeconds:        10
								timeoutSeconds:       5
								failureThreshold:     18
							}
						}
						startup: {
							enabled: true
							custom:  true
							spec: {
								httpGet: {
									path: "/api/v1/ready"
									port: 8080
								}
								initialDelaySeconds: 40
								periodSeconds:        10
								timeoutSeconds:       5
								failureThreshold:     36
							}
						}
					}
					...
				}
				postgres: {
					image: {
						repository: "pgvector/pgvector"
						tag:        "pg17"
					}
					env: {
						POSTGRES_USER:     "silo"
						POSTGRES_PASSWORD: "silo"
						POSTGRES_DB:       "silo"
					}
					resources: {
						requests: {cpu: "50m", memory: "128Mi"}
						limits: {memory: "512Mi"}
					}
				}
				redis: {
					image: {
						repository: "redis"
						tag:        "alpine"
					}
					resources: {
						requests: {cpu: "10m", memory: "32Mi"}
						limits: {memory: "128Mi"}
					}
				}
			}
		}
		persistence: {
			"silo-data": {
				enabled:      true
				type:         "persistentVolumeClaim"
				accessMode:   "ReadWriteOnce"
				size:         "5Gi"
				storageClass: "{{ kube.storage.default }}"
				globalMounts: [
					{path: "/var/lib/silo"},
				]
			}
			"silo-transcode": {
				enabled:      true
				type:         "persistentVolumeClaim"
				accessMode:   "ReadWriteOnce"
				size:         "10Gi"
				storageClass: "{{ kube.storage.default }}"
				globalMounts: [
					{path: "/tmp/silo-transcode"},
				]
			}
			"postgres-data": {
				enabled:      true
				type:         "persistentVolumeClaim"
				accessMode:   "ReadWriteOnce"
				size:         "10Gi"
				storageClass: "{{ kube.storage.default }}"
				advancedMounts: main: postgres: [
					{path: "/var/lib/postgresql"},
				]
			}
			"redis-data": {
				enabled:      true
				type:         "persistentVolumeClaim"
				accessMode:   "ReadWriteOnce"
				size:         "1Gi"
				storageClass: "{{ kube.storage.default }}"
				advancedMounts: main: {
					redis: [
						{path: "/data"},
					]
					"init-redis-permissions": [
						{path: "/data"},
					]
				}
			}
			media: {
				enabled: true
				type:    "nfs"
				server:  "{{ network.infra.synology.address }}"
				path:    "{{ network.infra.synology.services.nfs.path }}/Media"
				globalMounts: [
					{path: "/mnt/media"},
				]
			}
		}
	}
}
