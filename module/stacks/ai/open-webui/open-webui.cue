// vim: set ts=2 sw=2 et :
package open_webui

import (
	"github.com/epcim/mxc/schema"
)

#OpenWebUI: S=schema.#App & {
	_flavor: {
		small: {
			values: resources: {
				requests: {cpu: "100m", memory: "512Mi"}
				limits: {cpu: "2", memory: "2Gi"}
			}
		}
		medium: {
			values: resources: {
				requests: {cpu: "250m", memory: "1Gi"}
				limits: {cpu: "4", memory: "4Gi"}
			}
		}
	}

	appName:      "open-webui"
	appDesc:      "Open WebUI user interface for LLMs"
	adapter:      "kluctl"
	valuesSchema: string | *"https://raw.githubusercontent.com/open-webui/helm-charts/main/charts/open-webui/values.schema.json"

	helmChart: {
		repo:         "https://helm.openwebui.com/"
		chartName:    "open-webui"
		chartVersion: "5.15.0"
		releaseName:  "open-webui"
		namespace:    kustomize.namespace
		skipPrePull:  true
	}

	kustomize: {
		namespace: "llm"
		labels: [{
			pairs: app: "open-webui"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}

	secrets: {
		openai_api_key?: string
	}

	values: {
		image: {
			repository: "ghcr.io/open-webui/open-webui"
			tag:        "main"
		}
		ollama: {
			enabled: false
		}
		openaiBaseApiUrl: "http://litellm.llm.svc.cluster.local:4000/v1"
		extraEnvVars: [
			if secrets.openai_api_key != _|_ {
				name:  "OPENAI_API_KEY"
				value: secrets.openai_api_key
			},
			{
				name:  "WEBUI_AUTH"
				value: "true"
			},
			{
				name:  "ENABLE_SIGNUP"
				value: "false"
			},
			{
				name:  "ENABLE_COMMUNITY_SHARING"
				value: "false"
			},
			{
				name:  "WEBUI_NAME"
				value: "Homelab AI"
			},
		]
		persistence: {
			enabled:      true
			size:         "10Gi"
			storageClass: "longhorn"
		}
		ingress: {
			enabled: bool | *true
			class:   string | *"traefik"
			host:    S.appFqdn
			annotations: {
				"hajimari.io/enable":   "true"
				"hajimari.io/icon":     "chat-processing"
				"hajimari.io/group":    "productivity"
				"hajimari.io/appName":  "Open WebUI"
				"hajimari.io/instance": "svc"
				...
			}
		}
	}

	tags: ["ai", "llm", "open-webui"]
	flavor: string | *"small"

	_flavor[S.flavor]
}
