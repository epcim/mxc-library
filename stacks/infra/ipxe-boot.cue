// vim: set ts=2 sw=2 et :
package infra

import "github.com/epcim/mxc/schema"

#IPXEBoot: S=schema.#AppCore & {
	appName:    "ipxe-boot"
	deployment: "kluctl"
	contextSchema: "#app-template"
	image: {
		repository: "caddy"
		tag:        "2.8.4-alpine"
	}
	ports: {
		http: {
			port: 80 // Direct Port 80 exposure for BIOS HTTP boots
		}
	}
	expose: {
		http: {
			target: "loadbalancer" // Dedicated MetalLB LoadBalancer IP
		}
	}
	kustomize: {
		namespace: "zone-service"
		labels: [{
			pairs: app: "ipxe-boot"
		}]
		resources: [
			"helm-rendered.yaml",
			"overlays/ipxe-boot/configmap.yml", // Inject dynamically compiled physical config files!
			"overlays/network-policy.yaml",
			...string
		]
	}

	context: {
		ingress: {
			[string]: _
		}
		controllers: main: {
			containers: main: {
				image: {
					repository: S.image.repository
					tag:        S.image.tag
				}
				args: [
					"caddy",
					"run",
					"--config",
					"/etc/caddy/Caddyfile",
					"--adapter",
					"caddyfile",
				]
			}
		}

		// Configure the service to expose Caddy over a dedicated LoadBalancer IP on port 80
		service: main: {
			enabled: true
			primary: true
			type:    "LoadBalancer"
			ports: http: {
				port:       80
				targetPort: 80
			}
			[string]: _ // Allow extensible cluster-specific service overrides (annotations, spec, etc.)
		}

		// Mount ConfigMap files into Caddy webroot
		persistence: {
			caddyfile: {
				type: "configMap"
				name: "ipxe-boot-config"
				advancedMounts: main: main: [{
					path:     "/etc/caddy/Caddyfile"
					subPath:  "Caddyfile"
					readOnly: true
				}]
			}
			webroot: {
				type: "configMap"
				name: "ipxe-boot-config"
				advancedMounts: main: main: [
					{
						path:     "/usr/share/caddy/boot.ipxe"
						subPath:  "boot.ipxe"
						readOnly: true
					},
					{
						path:     "/usr/share/caddy/profiles/525400123456.ipxe"
						subPath:  "sample-profile.ipxe"
						readOnly: true
					},
					{
						path:     "/usr/share/caddy/profiles/default.ipxe"
						subPath:  "default-profile.ipxe"
						readOnly: true
					},
					{
						path:     "/usr/share/caddy/talos/controlplane.yaml"
						subPath:  "controlplane.yaml"
						readOnly: true
					},
					{
						path:     "/usr/share/caddy/talos/worker.yaml"
						subPath:  "worker.yaml"
						readOnly: true
					},
				]
			}
			assets: {
				if existingClaim == _|_ {
					type:       "persistentVolumeClaim"
					size:       *"2Gi" | string
					accessMode: *"ReadWriteOnce" | string
				}
				enabled?:       bool
				existingClaim?: string
				storageClass?:  string
				advancedMounts: main: main: [{
					path:     "/usr/share/caddy/assets"
					readOnly: false
				}]
			}
		}
	}

	tags: ["infra", "ipxe-boot"]
}
