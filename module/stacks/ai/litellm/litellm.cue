// vim: set ts=2 sw=2 et :
package litellm

import (
	"github.com/epcim/mxc/schema"
)

#LiteLLM: S=schema.#App & {
	_flavor: {
		small: {
			values: resources: {
				requests: {cpu: "100m", memory: "256Mi"}
				limits: {cpu: "1", memory: "1Gi"}
			}
		}
		medium: {
			values: resources: {
				requests: {cpu: "250m", memory: "512Mi"}
				limits: {cpu: "2", memory: "2Gi"}
			}
		}
	}

	appName:      "litellm"
	appDesc:      "LiteLLM OpenAI-compatible proxy and load balancer"
	adapter:      "kluctl"
	valuesSchema: string | *"https://raw.githubusercontent.com/BerriAI/litellm/main/values.schema.json"

	helmChart: {
		repo:         "https://berriai.github.io/litellm"
		chartName:    "litellm"
		chartVersion: "0.1.0"
		releaseName:  "litellm"
		namespace:    kustomize.namespace
	}

	kustomize: {
		namespace: "llm"
		labels: [{
			pairs: app: "litellm"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}

	secrets: {
		master_key?:       string
		scaleway_api_key?: string
	}

	values: {
		image: {
			repository: "ghcr.io/berriai/litellm"
			tag:        "main-v1.61.16"
			pullPolicy: "IfNotPresent"
		}
		service: {
			type: "ClusterIP"
			port: 4000
		}
		proxyConfigMap: {
			create: true
			key:    "config.yaml"
		}
		proxy_config: {
			general_settings: {
				master_key: "os.environ/LITELLM_MASTER_KEY"
			}
			router_settings: {
				routing_strategy: "latency-based-routing"
				num_retries:      3
				request_timeout:  120
				fallbacks: [
					{"local-fast": ["cloud-fast"]},
					{"cloud-reasoning": ["cloud-fast"]},
				]
			}
			model_list: [
				{
					model_name: "local-fast"
					litellm_params: {
						model:    "openai/qwen2.5-coder-7b"
						api_base: "http://llama-cpp.llm.svc.cluster.local:8080/v1"
						api_key:  "dummy"
					}
				},
				{
					model_name: "cloud-fast"
					litellm_params: {
						model:    "openai/meta/llama-3.1-8b-instruct"
						api_base: "https://api.scaleway.ai/v1"
						api_key:  "os.environ/SCALEWAY_API_KEY"
					}
				},
				{
					model_name: "cloud-reasoning"
					litellm_params: {
						model:    "openai/deepseek/deepseek-r1"
						api_base: "https://api.scaleway.ai/v1"
						api_key:  "os.environ/SCALEWAY_API_KEY"
					}
				},
				{
					model_name: "cloud-large"
					litellm_params: {
						model:    "openai/meta/llama-3.3-70b-instruct"
						api_base: "https://api.scaleway.ai/v1"
						api_key:  "os.environ/SCALEWAY_API_KEY"
					}
				},
				{
					model_name: "default"
					litellm_params: {
						model:    "openai/meta/llama-3.1-8b-instruct"
						api_base: "https://api.scaleway.ai/v1"
						api_key:  "os.environ/SCALEWAY_API_KEY"
					}
				},
			]
		}
		env: {
			if secrets.master_key != _|_ {
				LITELLM_MASTER_KEY: secrets.master_key
			}
			if secrets.scaleway_api_key != _|_ {
				SCALEWAY_API_KEY: secrets.scaleway_api_key
			}
		}
		ingress: {
			enabled:          bool | *true
			ingressClassName: string | *"traefik"
			annotations: {
				"hajimari.io/enable":   "true"
				"hajimari.io/icon":     "robot"
				"hajimari.io/group":    "infra"
				"hajimari.io/appName":  "LiteLLM"
				"hajimari.io/instance": "svc"
				"traefik.ingress.kubernetes.io/router.middlewares": "sys-auth-authelia@kubernetescrd"
				...
			}
			hosts: [
				{
					host: [if S.appFqdn != _|_ {S.appFqdn}, "litellm.apealive.net"][0]
					paths: [
						{
							path:     "/"
							pathType: "Prefix"
						},
					]
				},
			]
		}
	}

	tags: ["ai", "llm", "litellm"]
	flavor: string | *"small"

	_flavor[S.flavor]
}
