// Traefik Proxy Helm Chart
//
// The Cloud Native Application Proxy
package traefik

#ValuesSchema: {
	@jsonschema(schema="https://json-schema.org/draft/2020-12/schema")
	@jsonschema(id="https://traefik.io/traefik-helm-chart.schema.json")
	additionalArguments?: [...]
	additionalVolumeMounts?: [...]
	affinity?: {
		...
	}
	autoscaling?: {
		enabled?: bool
		...
	}
	certificatesResolvers?: {
		...
	}
	commonLabels?: {
		...
	}
	core?: close({
		defaultRuleSyntax?: string
	})
	deployment?: {
		additionalContainers?: [...]
		additionalVolumes?: [...]
		annotations?: {
			...
		}
		dnsConfig?: {
			...
		}
		dnsPolicy?:          string
		enabled?:            bool
		healthchecksHost?:   string
		healthchecksPort?:   null | int & >=0
		healthchecksScheme?: "HTTP" | "HTTPS" | null
		hostAliases?: [...]
		imagePullSecrets?: [...]
		initContainers?: [...]
		kind?: string
		labels?: {
			...
		}
		lifecycle?: {
			...
		}
		livenessPath?:    string
		minReadySeconds?: int
		podAnnotations?: {
			...
		}
		podLabels?: {
			...
		}
		readinessPath?:                 string
		replicas?:                      int
		revisionHistoryLimit?:          null | int & >=0
		runtimeClassName?:              string
		shareProcessNamespace?:         bool
		terminationGracePeriodSeconds?: int
		...
	}
	env?: [...]
	envFrom?: [...]
	experimental?: {
		abortOnPluginFailure?: bool
		fastProxy?: {
			debug?:   bool
			enabled?: bool
			...
		}
		kubernetesGateway?: {
			enabled?: bool
			...
		}
		plugins?: {
			...
		}
		...
	}
	extraObjects?: [...]
	gateway?: {
		annotations?: {
			...
		}
		enabled?: bool
		infrastructure?: {
			...
		}
		listeners?: {
			web?: {
				hostname?:        string
				namespacePolicy?: null | string
				port?:            int
				protocol?:        string
				...
			}
			...
		}
		name?:      string
		namespace?: string
		...
	}
	gatewayClass?: close({
		enabled?: bool
		labels?: {
			...
		}
		name?: string
	})
	globalArguments?: [...string]
	hostNetwork?: bool
	hub?: {
		apimanagement?: {
			admission?: {
				listenAddr?: string
				secretName?: string
				...
			}
			enabled?: bool
			openApi?: {
				validateRequestMethodAndPath?: bool
				...
			}
			...
		}
		experimental?: {
			aigateway?: bool
			...
		}
		redis?: {
			cluster?:   null | bool
			database?:  null | string
			endpoints?: string
			password?:  string
			sentinel?: {
				masterset?: string
				password?:  string
				username?:  string
				...
			}
			timeout?: string
			tls?: {
				ca?:                 string
				cert?:               string
				insecureSkipVerify?: bool
				key?:                string
				...
			}
			username?: string
			...
		}
		sendlogs?: null | bool
		token?:    string
		tracing?: {
			additionalTraceHeaders?: {
				enabled?: bool
				traceContext?: {
					parentId?:    string
					traceId?:     string
					traceParent?: string
					traceState?:  string
					...
				}
				...
			}
			...
		}
		...
	}
	image?: close({
		pullPolicy?: string
		registry?:   string
		repository?: string
		tag?:        null | string
	})
	ingressClass?: close({
		enabled?:        bool
		isDefaultClass?: bool
		name?:           string
	})
	ingressRoute?: {
		dashboard?: {
			annotations?: {
				...
			}
			enabled?: bool
			entryPoints?: [...string]
			labels?: {
				...
			}
			matchRule?: string
			middlewares?: [...]
			services?: [...{
				kind?: string
				name?: string
				...
			}]
			tls?: {
				...
			}
			...
		}
		healthcheck?: {
			annotations?: {
				...
			}
			enabled?: bool
			entryPoints?: [...string]
			labels?: {
				...
			}
			matchRule?: string
			middlewares?: [...]
			services?: [...{
				kind?: string
				name?: string
				...
			}]
			tls?: {
				...
			}
			...
		}
		...
	}
	instanceLabelOverride?: string
	livenessProbe?: close({
		failureThreshold?:    int
		initialDelaySeconds?: int
		periodSeconds?:       int
		successThreshold?:    int
		timeoutSeconds?:      int
	})
	logs?: {
		access?: {
			addInternals?:  bool
			bufferingSize?: null | int
			enabled?:       bool
			fields?: {
				general?: {
					defaultmode?: "keep" | "drop" | "redact"
					names?: {
						...
					}
					...
				}
				headers?: {
					defaultmode?: "keep" | "drop" | "redact"
					names?: {
						...
					}
					...
				}
				...
			}
			filters?: close({
				minduration?:   string
				retryattempts?: bool
				statuscodes?:   string
			})
			format?: "common" | "json" | null
			...
		}
		general?: {
			filePath?: string
			format?:   "common" | "json" | null
			level?:    "TRACE" | "DEBUG" | "INFO" | "WARN" | "ERROR" | "FATAL" | "PANIC"
			noColor?:  bool
			...
		}
		...
	}
	metrics?: {
		addInternals?: bool
		otlp?: {
			addEntryPointsLabels?: null | bool
			addRoutersLabels?:     null | bool
			addServicesLabels?:    null | bool
			enabled?:              bool
			explicitBoundaries?: [...]
			grpc?: {
				enabled?:  bool
				endpoint?: string
				insecure?: bool
				tls?: {
					ca?:                 string
					cert?:               string
					insecureSkipVerify?: bool
					key?:                string
					...
				}
				...
			}
			http?: {
				enabled?:  bool
				endpoint?: string
				headers?: {
					...
				}
				tls?: {
					ca?:                 string
					cert?:               string
					insecureSkipVerify?: null | bool
					key?:                string
					...
				}
				...
			}
			pushInterval?: string
			...
		}
		prometheus?: {
			addEntryPointsLabels?: null | bool
			addRoutersLabels?:     null | bool
			addServicesLabels?:    null | bool
			buckets?:              string
			disableAPICheck?:      null | bool
			entryPoint?:           string
			manualRouting?:        bool
			prometheusRule?: {
				additionalLabels?: {
					...
				}
				enabled?:   bool
				namespace?: string
				...
			}
			service?: {
				annotations?: {
					...
				}
				enabled?: bool
				labels?: {
					...
				}
				...
			}
			serviceMonitor?: {
				additionalLabels?: {
					...
				}
				enableHttp2?:     bool
				enabled?:         bool
				followRedirects?: bool
				honorLabels?:     bool
				honorTimestamps?: bool
				interval?:        string
				jobLabel?:        string
				metricRelabelings?: [...]
				namespace?: string
				namespaceSelector?: {
					...
				}
				relabelings?: [...]
				scrapeTimeout?: string
				...
			}
			...
		}
		...
	}
	namespaceOverride?: string
	nodeSelector?: {
		...
	}
	persistence?: {
		accessMode?: string
		annotations?: {
			...
		}
		enabled?:       bool
		existingClaim?: string
		name?:          string
		path?:          string
		size?:          string
		storageClass?:  string
		subPath?:       string
		volumeName?:    string
		...
	}
	podDisruptionBudget?: close({
		enabled?:        bool
		maxUnavailable?: null | int & >=0 | string
		minAvailable?:   null | int & >=0 | string
	})
	podSecurityContext?: {
		runAsGroup?:   int
		runAsNonRoot?: bool
		runAsUser?:    int
		...
	}
	podSecurityPolicy?: {
		enabled?: bool
		...
	}
	ports?: {
		metrics?: {
			expose?: {
				default?: bool
				...
			}
			exposedPort?: int
			port?:        int
			protocol?:    string
			...
		}
		traefik?: {
			expose?: {
				default?: bool
				...
			}
			exposedPort?: int
			hostIP?:      null | string
			hostPort?:    null | int & >=0
			port?:        int
			protocol?:    string
			...
		}
		web?: {
			expose?: {
				default?: bool
				...
			}
			exposedPort?: int
			forwardedHeaders?: {
				insecure?: bool
				trustedIPs?: [...]
				...
			}
			nodePort?: null | int & >=0
			port?:     int
			protocol?: string
			proxyProtocol?: {
				insecure?: bool
				trustedIPs?: [...]
				...
			}
			redirections?: {
				entryPoint?: {
					...
				}
				...
			}
			targetPort?: null | int & >=0 | string
			transport?: {
				keepAliveMaxRequests?: null | int & >=0
				keepAliveMaxTime?:     null | int | string
				lifeCycle?: {
					graceTimeOut?:              null | int | string
					requestAcceptGraceTimeout?: null | int | string
					...
				}
				respondingTimeouts?: {
					idleTimeout?:  null | int | string
					readTimeout?:  null | int | string
					writeTimeout?: null | int | string
					...
				}
				...
			}
			...
		}
		websecure?: {
			allowACMEByPass?: bool
			appProtocol?:     null | string
			containerPort?:   null | int & >=0
			expose?: {
				default?: bool
				...
			}
			exposedPort?: int
			forwardedHeaders?: {
				insecure?: bool
				trustedIPs?: [...]
				...
			}
			hostPort?: null | int & >=0
			http3?: {
				advertisedPort?: null | int & >=0
				enabled?:        bool
				...
			}
			middlewares?: [...]
			nodePort?: null | int & >=0
			port?:     int
			protocol?: string
			proxyProtocol?: {
				insecure?: bool
				trustedIPs?: [...]
				...
			}
			targetPort?: null | int & >=0 | string
			tls?: {
				certResolver?: string
				domains?: [...]
				enabled?: bool
				options?: string
				...
			}
			transport?: {
				keepAliveMaxRequests?: null | int & >=0
				keepAliveMaxTime?:     null | int | string
				lifeCycle?: {
					graceTimeOut?:              null | int | string
					requestAcceptGraceTimeout?: null | int | string
					...
				}
				respondingTimeouts?: {
					idleTimeout?:  null | int | string
					readTimeout?:  null | int | string
					writeTimeout?: null | int | string
					...
				}
				...
			}
			...
		}
		...
	}
	priorityClassName?: string
	providers?: close({
		file?: {
			content?: string
			enabled?: bool
			watch?:   bool
			...
		}
		kubernetesCRD?: {
			allowCrossNamespace?:       bool
			allowEmptyServices?:        bool
			allowExternalNameServices?: bool
			enabled?:                   bool
			ingressClass?:              string
			namespaces?: [...]
			nativeLBByDefault?: bool
			...
		}
		kubernetesGateway?: {
			enabled?:             bool
			experimentalChannel?: bool
			labelselector?:       string
			namespaces?: [...]
			nativeLBByDefault?: bool
			statusAddress?: {
				hostname?: string
				ip?:       string
				service?: {
					enabled?:   bool
					name?:      string
					namespace?: string
					...
				}
				...
			}
			...
		}
		kubernetesIngress?: {
			allowEmptyServices?:        bool
			allowExternalNameServices?: bool
			enabled?:                   bool
			ingressClass?:              null | string
			namespaces?: [...]
			nativeLBByDefault?: bool
			publishedService?: {
				enabled?:      bool
				pathOverride?: string
				...
			}
			...
		}
	})
	rbac?: close({
		aggregateTo?: [...]
		enabled?:    bool
		namespaced?: bool
		secretResourceNames?: [...]
	})
	readinessProbe?: close({
		failureThreshold?:    int
		initialDelaySeconds?: int
		periodSeconds?:       int
		successThreshold?:    int
		timeoutSeconds?:      int
	})
	resources?: {
		...
	}
	securityContext?: {
		allowPrivilegeEscalation?: bool
		capabilities?: {
			drop?: [...string]
			...
		}
		readOnlyRootFilesystem?: bool
		...
	}
	service?: {
		additionalServices?: {
			...
		}
		annotations?: {
			...
		}
		annotationsTCP?: {
			...
		}
		annotationsUDP?: {
			...
		}
		enabled?: bool
		externalIPs?: [...]
		labels?: {
			...
		}
		loadBalancerSourceRanges?: [...string]
		single?: bool
		spec?: {
			...
		}
		type?: string
		...
	}
	serviceAccount?: close({
		name?: string
	})
	serviceAccountAnnotations?: {
		...
	}
	startupProbe?: {
		...
	}
	tlsOptions?: {
		...
	}
	tlsStore?: {
		...
	}
	tolerations?: [...]
	topologySpreadConstraints?: [...]
	tracing?: close({
		addInternals?: bool
		capturedRequestHeaders?: [...]
		capturedResponseHeaders?: [...]
		otlp?: {
			enabled?: bool
			grpc?: {
				enabled?:  bool
				endpoint?: string
				insecure?: bool
				tls?: {
					ca?:                 string
					cert?:               string
					insecureSkipVerify?: bool
					key?:                string
					...
				}
				...
			}
			http?: {
				enabled?:  bool
				endpoint?: string
				headers?: {
					...
				}
				tls?: {
					ca?:                 string
					cert?:               string
					insecureSkipVerify?: bool
					key?:                string
					...
				}
				...
			}
			...
		}
		resourceAttributes?: {
			...
		}
		safeQueryParams?: [...]
		sampleRate?:  null | <=1 & >=0
		serviceName?: null | string
	})
	updateStrategy?: close({
		rollingUpdate?: {
			maxSurge?:       null | int | string
			maxUnavailable?: null | int | string
			...
		}
		type?: string
	})
	volumes?: [...]
	...
}
