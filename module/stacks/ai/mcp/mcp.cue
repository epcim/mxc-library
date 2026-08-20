// vim: set ts=2 sw=2 et :
package mcp

import "github.com/epcim/mxc/schema"

// #McpFetch defines an MCP server to fetch HTTP web pages and markdown.
#McpFetch: S=schema.#App & {
	appName:    "mcp-fetch"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "ghcr.io/sparfenyuk/mcp-proxy"
		tag:        "latest"
	}
	ports: {
		http: {
			port: 8080
		}
	}
	expose: {
		http: {
			target: "internal"
		}
	}
	values: {
		controllers: {
			main: {
				containers: {
					main: {
						args: [
							"--port",
							"8080",
							"--",
							"uvx",
							"mcp-server-fetch",
						]
					}
				}
			}
		}
	}
	kustomize: {
		namespace: "llm"
		labels: [{
			pairs: app: "mcp-fetch"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	tags: ["ai", "mcp", "fetch"]

	_flavor: {
		nano: {
			values: controllers: main: containers: main: resources: {
				limits: { cpu: "200m", memory: "256Mi" }
				requests: { cpu: "50m", memory: "64Mi" }
			}
		}
		small: {
			values: controllers: main: containers: main: resources: {
				limits: { cpu: "500m", memory: "512Mi" }
				requests: { cpu: "100m", memory: "128Mi" }
			}
		}
	}
	flavor: string | *"nano"
	_flavor[S.flavor]
}

// #McpTime defines an MCP server providing current time and timezone utilities.
#McpTime: S=schema.#App & {
	appName:    "mcp-time"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "ghcr.io/sparfenyuk/mcp-proxy"
		tag:        "latest"
	}
	ports: {
		http: {
			port: 8080
		}
	}
	expose: {
		http: {
			target: "internal"
		}
	}
	values: {
		controllers: {
			main: {
				containers: {
					main: {
						args: [
							"--port",
							"8080",
							"--",
							"uvx",
							"mcp-server-time",
						]
					}
				}
			}
		}
	}
	kustomize: {
		namespace: "llm"
		labels: [{
			pairs: app: "mcp-time"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	tags: ["ai", "mcp", "time"]

	_flavor: {
		nano: {
			values: controllers: main: containers: main: resources: {
				limits: { cpu: "200m", memory: "256Mi" }
				requests: { cpu: "50m", memory: "64Mi" }
			}
		}
		small: {
			values: controllers: main: containers: main: resources: {
				limits: { cpu: "500m", memory: "512Mi" }
				requests: { cpu: "100m", memory: "128Mi" }
			}
		}
	}
	flavor: string | *"nano"
	_flavor[S.flavor]
}

// #McpGit defines an MCP server for Git repository inspection and operations.
#McpGit: S=schema.#App & {
	appName:    "mcp-git"
	deployment: "kluctl"
	valuesSchema: "#app-template"
	image: {
		repository: "ghcr.io/sparfenyuk/mcp-proxy"
		tag:        "latest"
	}
	ports: {
		http: {
			port: 8080
		}
	}
	expose: {
		http: {
			target: "internal"
		}
	}
	values: {
		controllers: {
			main: {
				containers: {
					main: {
						args: [
							"--port",
							"8080",
							"--",
							"uvx",
							"mcp-server-git",
						]
					}
				}
			}
		}
	}
	kustomize: {
		namespace: "llm"
		labels: [{
			pairs: app: "mcp-git"
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	tags: ["ai", "mcp", "git"]

	_flavor: {
		nano: {
			values: controllers: main: containers: main: resources: {
				limits: { cpu: "200m", memory: "256Mi" }
				requests: { cpu: "50m", memory: "64Mi" }
			}
		}
		small: {
			values: controllers: main: containers: main: resources: {
				limits: { cpu: "500m", memory: "512Mi" }
				requests: { cpu: "100m", memory: "128Mi" }
			}
		}
	}
	flavor: string | *"nano"
	_flavor[S.flavor]
}
