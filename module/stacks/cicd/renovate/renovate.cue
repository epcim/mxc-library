package renovate

import (
	"strings"
	"github.com/epcim/mxc/schema"
)

#Renovate: schema.#App & {
	appName:    "renovate"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "code.forgejo.org/renovate/renovate"
		tag:        "latest"
	}
	kustomize: {
		namespace: "gitops"
		labels: [{
			pairs: app: "renovate"
		}]
	}
	values: {
		ingress: main: enabled: false
		controllers: main: {
			[string]: _
			type: "cronjob"
			cronjob: {
				schedule: "0 * * * *"
				concurrencyPolicy: "Forbid"
			}
			containers: main: {
				probes: {
					liveness: enabled:  false
					readiness: enabled: false
					startup: enabled:   false
				}
				env: {
					TZ:                    "Europe/Prague"
					RENOVATE_PLATFORM:     "forgejo"
					RENOVATE_ENDPOINT:     string | *"https://forgejo.FIXME/api/v1/"
					RENOVATE_TOKEN:        string | *"{{ secrets.renovate.token }}"
					RENOVATE_GIT_AUTHOR:   "Renovate Bot <renovate@{{ args.domain }}>"
					RENOVATE_REPOSITORIES: "{{ get_var(\"stack.renovate.repositories\", \"epcim/gitops-infra\") }}"
					RENOVATE_AUTODISCOVER: string | *"true"
					LOG_LEVEL:             "info"

					let scheme = strings.Split(RENOVATE_ENDPOINT, "://")[0]
					let clean_url = strings.Replace(strings.Replace(RENOVATE_ENDPOINT, "https://", "", 1), "http://", "", 1)
					let host_parts = strings.Split(clean_url, "/")
					let host = host_parts[0]
					let naked_host = strings.Split(host, ":")[0]
					let host_with_scheme = "\(scheme)://\(host)"

					RENOVATE_CONFIG:       "{\"hostRules\": [{\"matchHost\": \"\(naked_host)\", \"token\": \"{{ secrets.renovate.token }}\"},{\"matchHost\": \"\(host_with_scheme)\", \"token\": \"{{ secrets.renovate.token }}\"}]}"
					[string]:              string
				}
			}
		}
	}
	tags: ["cicd", "renovate"]
}
