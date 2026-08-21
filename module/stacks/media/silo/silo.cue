// vim: set ts=2 sw=2 et :
package silo

import "github.com/epcim/mxc/schema"

#Silo: S=schema.#App & {
	_flavor: {
		small: {
			values: controllers: main: {
				containers: {
					main: resources: {
						requests: {cpu: "100m", memory: "256Mi"}
						limits: {memory: "1Gi"}
					}
					postgres: resources: {
						requests: {cpu: "50m", memory: "128Mi"}
						limits: {memory: "512Mi"}
					}
					redis: resources: {
						requests: {cpu: "10m", memory: "32Mi"}
						limits: {memory: "128Mi"}
					}
				}
			}
			storage: {
				"silo-data": size:      string | *"5Gi"
				"redis-data": size:     string | *"1Gi"
				"postgres-data": size:  string | *"10Gi"
				"silo-transcode": size: string | *"10Gi"
			}
		}
		medium: {
			values: controllers: main: {
				containers: {
					main: resources: {
						requests: {cpu: "250m", memory: "512Mi"}
						limits: {memory: "2Gi"}
					}
					postgres: resources: {
						requests: {cpu: "100m", memory: "256Mi"}
						limits: {memory: "1Gi"}
					}
					redis: resources: {
						requests: {cpu: "20m", memory: "64Mi"}
						limits: {memory: "256Mi"}
					}
				}
			}
			storage: {
				"silo-data": size:      string | *"20Gi"
				"redis-data": size:     string | *"2Gi"
				"postgres-data": size:  string | *"20Gi"
				"silo-transcode": size: string | *"20Gi"
			}
		}
	}

	appName:    string | *"silo"
	deployment: string | *"kluctl"
	valuesSchema: "#app-template"
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
		"postgres-data": {
			size:  string | *"10Gi"
			class: string | *"longhorn"
		}
		"silo-transcode": {
			size:  string | *"10Gi"
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
	flavor: string | *"small"

	kustomize: {
		namespace: "media"
		labels: [{
			pairs: app: "silo"
		}]
		...
	}
	values: {
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
				}
				redis: {
					image: {
						repository: "redis"
						tag:        "alpine"
					}
				}
			}
		}
		persistence: {
			"silo-data": {
				existingClaim: "\(appName)-silo-data"
				globalMounts: [
					{path: "/var/lib/silo"},
				]
			}
			"silo-transcode": {
				existingClaim: "\(appName)-silo-transcode"
				globalMounts: [
					{path: "/tmp/silo-transcode"},
				]
			}
			"postgres-data": {
				existingClaim: "\(appName)-postgres-data"
				advancedMounts: main: postgres: [
					{path: "/var/lib/postgresql"},
				]
			}
			"redis-data": {
				existingClaim: "\(appName)-redis-data"
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
				server:  string | *"nfs.local"
				path:    string | *"/volume1/Media"
				globalMounts: [
					{path: "/mnt/media"},
				]
			}
		}
	}

	_flavor[S.flavor]
}

