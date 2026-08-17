@extern(embed)
package homarr

import (
	"encoding/yaml"
	"github.com/epcim/mxc/schema"
)

#Homarr: schema.#App & {
	appName:    "homarr"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "ghcr.io/ajnart/homarr"
		tag:        "0.16.0"
	}
	ports: {
		http: {
			port: 7575
		}
	}
	expose: {
		http: {
			target: "ingress"
			annotations: {
				"hajimari.io/enable":   "true"
				"hajimari.io/icon":     "view-dashboard"
				"hajimari.io/group":    "home"
				"hajimari.io/appName":  "Homarr"
				"hajimari.io/instance": "main,int"
			}
		}
	}
	secrets: {
		encryptionKey: string | *"{{ secrets.homarr.encryption_key }}"
	}
	values: {
		controllers: {
			main: {
				serviceAccount: {
					name: "homarr"
				}
				containers: {
					main: {
						env: {
							SECRET_ENCRYPTION_KEY: secrets.encryptionKey
						}
					}
				}
			}
		}
		persistence: {
			appdata: {
				enabled:       true
				type:          "persistentVolumeClaim"
				existingClaim: "homarr-appdata"
				globalMounts: [
					{path: "/appdata"},
				]
			}
		}
	}
	kustomize: {
		namespace: "home"
		labels: [{
			includeSelectors: true
			pairs: {
				app: "homarr"
			}
		}]
		overlays: yaml.UnmarshalStream(_rbacYAML)
	}
	tags: ["home", "homarr"]
}

_rbacYAML: _ @embed(file="rbac.yaml", type="text")
