// vim: set ts=2 sw=2 et :
package hajimari

import "github.com/epcim/mxc/schema"

// #HajimariMeta defines portal metadata for Hajimari dashboard registration.
#HajimariMeta: {
	enable:   bool | *true
	icon?:    string
	group?:   string
	appName?: string
	instance?: string | *"svc"
	url?:     string
	info?:    string
	target?:  string
}

// #WithHajimari provides an optional, pluggable trait to attach Hajimari
// portal annotations to an application's ingress or expose configuration.
#WithHajimari: {
	hajimari?: #HajimariMeta

	if hajimari != _|_ && (hajimari.enable & true) {
		expose: [string]: annotations: {
			"hajimari.io/enable": "true"
			if hajimari.icon != _|_ {
				"hajimari.io/icon": hajimari.icon
			}
			if hajimari.group != _|_ {
				"hajimari.io/group": hajimari.group
			}
			if hajimari.appName != _|_ {
				"hajimari.io/appName": hajimari.appName
			}
			if hajimari.instance != _|_ {
				"hajimari.io/instance": hajimari.instance
			}
			if hajimari.url != _|_ {
				"hajimari.io/url": hajimari.url
			}
			if hajimari.info != _|_ {
				"hajimari.io/info": hajimari.info
			}
			if hajimari.target != _|_ {
				"hajimari.io/target": hajimari.target
			}
		}
	}
}

// #Hajimari defines the core Hajimari dashboard workload application.
#Hajimari: S=schema.#App & {
	appName:    "hajimari"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "ghcr.io/hajimari/hajimari"
		tag:        "v0.3.2"
	}
	ports: {
		http: {
			port: 80
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
			pairs: app: "hajimari"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	tags: ["home", "portal", "hajimari"]
	flavor: string | *"small"
}
