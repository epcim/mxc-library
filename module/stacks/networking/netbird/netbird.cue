// vim: set ts=2 sw=2 et :
package netbird

import "github.com/epcim/mxc/schema"

#NetBirdGateway: schema.#App & {
	appName:     string
	_hostname:   string | *appName
	_namespace:  string | *"netbird"
	_logLevel:   string | *"info"
	deployment: "kluctl"
	valuesSchema: "#app-template"

	secrets: {
		setup_key: string | *"{{ secrets.netbird.setup_key }}"
	}

	kustomize: {
		namespace: _namespace
		labels: [{
			pairs: app: appName
		}]
		resources: [
			"helm-rendered.yaml",
			"overlays/pvc.yaml",
		]
		generatorOptions: {
			disableNameSuffixHash: true
		}
		secretGenerator: [{
			name: "\(appName)-setup-key"
			literals: [
				"setup-key=" + secrets.setup_key,
			]
		}]
	}

	values: {
		controllers: main: {
			pod: labels: {
				app:  appName
				role: "gateway"
			}
			containers: main: {
				image: {
					repository: "netbirdio/netbird"
					tag:        "0.65.0"
				}
				args: [...string] | *["up"]
				env: {
					NB_SETUP_KEY_FILE: "/etc/netbird-secret/setup-key"
					NB_HOSTNAME:       _hostname
					NB_LOG_LEVEL:      _logLevel
					TZ:                "Europe/Prague"
					[string]:          string
				}
				resources: {
					requests: {
						cpu:    "10m"
						memory: "32Mi"
					}
					limits: {
						cpu:    "100m"
						memory: "64Mi"
					}
				}
				securityContext: {
					capabilities: add: ["NET_ADMIN", "SYS_ADMIN"]
					privileged: true
				}
				probes: {
					liveness: enabled:  false
					readiness: enabled: false
					startup: enabled:   false
				}
			}
		}
		persistence: {
			"setup-key": {
				type: "secret"
				name: "\(appName)-setup-key"
				globalMounts: [{
					path:     "/etc/netbird-secret"
					readOnly: true
				}]
			}
		}
	}

	tags: ["networking", "netbird-client", appName]
}
