package networking

import "github.com/epcim/mxc/schema"

// Parameterized generator for standard namespace network policies
#NamespacePolicies: {
	#Namespace: string

	denyAll: schema.#K8sNetworkPolicy & {
		apiVersion: "networking.k8s.io/v1"
		kind:       "NetworkPolicy"
		metadata: {
			name:      "\(#Namespace)-default-deny"
			namespace: #Namespace
		}
		spec: {
			podSelector: {}
			policyTypes: ["Ingress", "Egress"]
		}
	}

	allowLocal: schema.#K8sNetworkPolicy & {
		apiVersion: "networking.k8s.io/v1"
		kind:       "NetworkPolicy"
		metadata: {
			name:      "\(#Namespace)-allow-intra-namespace"
			namespace: #Namespace
		}
		spec: {
			podSelector: {}
			policyTypes: ["Ingress", "Egress"]
			ingress: [{
				from: [{
					podSelector: {}
				}]
			}]
			egress: [{
				to: [{
					podSelector: {}
				}]
			}]
		}
	}

	allowIngress: schema.#K8sNetworkPolicy & {
		#SourceNamespace: string | *"zone-service"
		apiVersion: "networking.k8s.io/v1"
		kind:       "NetworkPolicy"
		metadata: {
			name:      "\(#Namespace)-allow-ingress-from-\(#SourceNamespace)"
			namespace: #Namespace
		}
		spec: {
			podSelector: {}
			policyTypes: ["Ingress"]
			ingress: [{
				from: [{
					namespaceSelector: {
						matchLabels: {
							"kubernetes.io/metadata.name": #SourceNamespace
						}
					}
				}]
			}]
		}
	}

	allowDNS: schema.#K8sNetworkPolicy & {
		apiVersion: "networking.k8s.io/v1"
		kind:       "NetworkPolicy"
		metadata: {
			name:      "\(#Namespace)-allow-dns"
			namespace: #Namespace
		}
		spec: {
			podSelector: {}
			policyTypes: ["Egress"]
			egress: [{
				to: [{
					namespaceSelector: {
						matchLabels: {
							"kubernetes.io/metadata.name": "kube-system"
						}
					}
				}]
				ports: [{
					protocol: "UDP"
					port:     53
				}, {
					protocol: "TCP"
					port:     53
				}]
			}]
		}
	}

	allowInternet: schema.#K8sNetworkPolicy & {
		apiVersion: "networking.k8s.io/v1"
		kind:       "NetworkPolicy"
		metadata: {
			name:      "\(#Namespace)-allow-internet"
			namespace: #Namespace
		}
		spec: {
			podSelector: {}
			policyTypes: ["Egress"]
			egress: [{
				to: [{
					ipBlock: {
						cidr: "0.0.0.0/0"
						except: [
							"10.0.0.0/8",
							"172.16.0.0/12",
							"192.168.0.0/16",
						]
					}
				}]
			}]
		}
	}
}
