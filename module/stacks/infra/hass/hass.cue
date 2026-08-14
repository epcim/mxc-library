// vim: set ts=2 sw=2 et :
package hass

import "github.com/epcim/mxc/schema"

#HomeAssistant: S=schema.#AppCore & {
	appName:    "hass"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "homeassistant/home-assistant"
		tag:        "stable"
	}
	ports: {
		http: {
			port: 8123
		}
	}
	expose: {
		http: {
			target: "ingress"
		}
	}
	kustomize: {
		namespace: "home"
		labels: [{
			pairs: app: "hass"
		}]
	}

	values: {
		controllers: main: {
			containers: main: {
				image: {
					repository: S.image.repository
					tag:        S.image.tag
				}
				securityContext: privileged: true
			}
			pod: {
				hostNetwork: true
				dnsPolicy:   "ClusterFirstWithHostNet"
				nodeSelector: "kubernetes.io/hostname": "cmp5"
			}
		}
		persistence: {
			config: {
				existingClaim: "hass-home-assistant-config"
				globalMounts: [{ path: "/config" }]
			}
			dbus: {
				type:     "hostPath"
				hostPath: "/run/dbus"
				globalMounts: [{ path: "/run/dbus", readOnly: true }]
			}
			bluetooth: {
				type:     "hostPath"
				hostPath: "/sys/class/bluetooth"
				globalMounts: [{ path: "/sys/class/bluetooth" }]
			}
		}
	}
	storage: {
		"home-assistant-config": {
			size:  string | *"20Gi"
			class: string | *"longhorn"
		}
	}

	tags: ["infra", "hass", "home-assistant"]
}
