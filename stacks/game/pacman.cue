// vim: set ts=2 sw=2 et :
package game

import "github.com/epcim/mxc/schema"

#Pacman: S=schema.#AppCore & {
	_flavor: {
		small: {
			context: resources: {
				limits: { cpu: "200m", memory: "128Mi" }
				requests: { cpu: "50m", memory: "64Mi" }
			}
		}
		medium: {
			context: resources: {
				limits: { cpu: "500m", memory: "256Mi" }
				requests: { cpu: "100m", memory: "128Mi" }
			}
		}
	}

	appName:    "pacman"
	deployment: "kluctl"
	contextSchema: "#app-template"
	image: {
		repository: "dbafromthecold/pac-man"
		tag:        "latest"
	}
	ports: {
		http: {
			port: 80
		}
	}
	expose: {
		http: {
			target: "ingress"
			annotations: {
				"traefik.ingress.kubernetes.io/router.entrypoints":     "websecure"
				"traefik.ingress.kubernetes.io/router.tls":             "true"
				"traefik.ingress.kubernetes.io/router.tls.certresolver": "cloudflare"
				"hajimari.io/enable":                                    "true"
				"hajimari.io/icon":                                      "ghost"
				"hajimari.io/group":                                     "games"
				"hajimari.io/appName":                                   "Pac-Man"
				"hajimari.io/instance":                                  "svc"
			}
		}
	}
	kustomize: {
		namespace: "game"
		labels: [{
			pairs: app: "pacman"
		}]
	}
	
	flavor: string | *"small"
	tags: ["game", "pacman"]
	
	_flavor[S.flavor]
}
