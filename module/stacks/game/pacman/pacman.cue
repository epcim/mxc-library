// vim: set ts=2 sw=2 et :
package pacman

import "github.com/epcim/mxc/schema"

#Pacman: S=schema.#App & {
	_flavor: {
		small: {
			values: resources: {
				limits: { cpu: "200m", memory: "128Mi" }
				requests: { cpu: "50m", memory: "64Mi" }
			}
		}
		medium: {
			values: resources: {
				limits: { cpu: "500m", memory: "256Mi" }
				requests: { cpu: "100m", memory: "128Mi" }
			}
		}
	}

	appName:    "pacman"
	deployment: "kluctl"
	valuesSchema: "#app-template"
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
				"hajimari.io/enable":   "true"
				"hajimari.io/icon":     "ghost"
				"hajimari.io/group":    "games"
				"hajimari.io/appName":  "Pac-Man"
				"hajimari.io/instance": "svc"
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
