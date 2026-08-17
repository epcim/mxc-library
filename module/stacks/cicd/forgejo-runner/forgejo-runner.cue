package forgejo_runner

import "github.com/epcim/mxc/schema"

#ForgejoRunner: schema.#App & {
	appName:    "forgejo-runner"
	deployment: "kluctl"
	image: {
		repository: "code.forgejo.org/forgejo/runner"
		tag:        "3.3.0"
	}
	kustomize: {
		namespace: "gitops"
		labels: [{
			pairs: app: "forgejo-runner"
		}]
		resources: [
			"helm-rendered.yaml"
		]
	}
	helmChart: {
		repo:         "oci://codeberg.org/wrenix/helm-charts/forgejo-runner"
		chartVersion: "0.6.21"
		releaseName:  "forgejo-runner"
		namespace:    kustomize.namespace
		skipCRDs:     false
		skipPrePull:  true
	}

	flavor: string | *"small"
	_flavor: {
		nano: {
			values: {
				resources: {
					limits: {cpu: "200m", memory: "256Mi"}
					requests: {cpu: "10m", memory: "64Mi"}
				}
			}
		}
		small: {
			values: {
				resources: {
					limits: {cpu: "500m", memory: "512Mi"}
					requests: {cpu: "100m", memory: "128Mi"}
				}
			}
		}
		medium: {
			values: {
				resources: {
					limits: {cpu: "1", memory: "1Gi"}
					requests: {cpu: "200m", memory: "256Mi"}
				}
			}
		}
	}

	// schema: none published upstream (chart maintainer confirms no values schema) -- source: https://codeberg.org/wrenix/helm-charts, oci://codeberg.org/wrenix/helm-charts/forgejo-runner
	values: {
		runner: {
			config: {
				create: true
				file: {
					log: {
						level: "info"
					}
					runner: {
						file:     ".runner"
						capacity: 1
						instance: "{{ get_var(\"secrets.woodpecker.forgejo.aalive.url\", \"https://forgejo.aalive.familyds.net:2222\") }}"
						token:    "{{ get_var(\"secrets.forgejo_runner.token\", \"\") }}"
						labels: [
							"self-hosted:docker://node:18-bullseye",
						]
					}
				}
			}
		}
		// Enable a small DinD sidecar to run docker steps inside jobs
		dind: {
			enabled: true
		}
	}

	tags: ["cicd", "forgejo-runner", "forgejo"]

	_flavor[flavor]
}
