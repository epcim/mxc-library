package cert_manager

#ValuesSchema: {
	@jsonschema(schema="http://json-schema.org/draft-07/schema#")

	#."helm-values"

	#: "helm-values": close({
		acmesolver?:                    #."helm-values.acmesolver"
		affinity?:                      #."helm-values.affinity"
		approveSignerNames?:            #."helm-values.approveSignerNames"
		automountServiceAccountToken?:  #."helm-values.automountServiceAccountToken"
		cainjector?:                    #."helm-values.cainjector"
		clusterResourceNamespace?:      #."helm-values.clusterResourceNamespace"
		config?:                        #."helm-values.config"
		containerSecurityContext?:      #."helm-values.containerSecurityContext"
		crds?:                          #."helm-values.crds"
		creator?:                       #."helm-values.creator"
		deploymentAnnotations?:         #."helm-values.deploymentAnnotations"
		disableAutoApproval?:           #."helm-values.disableAutoApproval"
		dns01RecursiveNameservers?:     #."helm-values.dns01RecursiveNameservers"
		dns01RecursiveNameserversOnly?: #."helm-values.dns01RecursiveNameserversOnly"
		enableCertificateOwnerRef?:     #."helm-values.enableCertificateOwnerRef"
		enableServiceLinks?:            #."helm-values.enableServiceLinks"
		enabled?:                       #."helm-values.enabled"
		extraArgs?:                     #."helm-values.extraArgs"
		extraEnv?:                      #."helm-values.extraEnv"
		extraObjects?:                  #."helm-values.extraObjects"
		featureGates?:                  #."helm-values.featureGates"
		fullnameOverride?:              #."helm-values.fullnameOverride"
		global?:                        #."helm-values.global"
		hostAliases?:                   #."helm-values.hostAliases"
		http_proxy?:                    #."helm-values.http_proxy"
		https_proxy?:                   #."helm-values.https_proxy"
		image?:                         #."helm-values.image"
		ingressShim?:                   #."helm-values.ingressShim"
		installCRDs?:                   #."helm-values.installCRDs"
		livenessProbe?:                 #."helm-values.livenessProbe"
		maxConcurrentChallenges?:       #."helm-values.maxConcurrentChallenges"
		nameOverride?:                  #."helm-values.nameOverride"
		namespace?:                     #."helm-values.namespace"
		no_proxy?:                      #."helm-values.no_proxy"
		nodeSelector?:                  #."helm-values.nodeSelector"
		podAnnotations?:                #."helm-values.podAnnotations"
		podDisruptionBudget?:           #."helm-values.podDisruptionBudget"
		podDnsConfig?:                  #."helm-values.podDnsConfig"
		podDnsPolicy?:                  #."helm-values.podDnsPolicy"
		podLabels?:                     #."helm-values.podLabels"
		prometheus?:                    #."helm-values.prometheus"
		replicaCount?:                  #."helm-values.replicaCount"
		resources?:                     #."helm-values.resources"
		securityContext?:               #."helm-values.securityContext"
		serviceAccount?:                #."helm-values.serviceAccount"
		serviceAnnotations?:            #."helm-values.serviceAnnotations"
		serviceIPFamilies?:             #."helm-values.serviceIPFamilies"
		serviceIPFamilyPolicy?:         #."helm-values.serviceIPFamilyPolicy"
		serviceLabels?:                 #."helm-values.serviceLabels"
		startupapicheck?:               #."helm-values.startupapicheck"
		strategy?:                      #."helm-values.strategy"
		tolerations?:                   #."helm-values.tolerations"
		topologySpreadConstraints?:     #."helm-values.topologySpreadConstraints"
		volumeMounts?:                  #."helm-values.volumeMounts"
		volumes?:                       #."helm-values.volumes"
		webhook?:                       #."helm-values.webhook"
	})

	#: "helm-values.acmesolver": close({
		image?: #."helm-values.acmesolver.image"
	})

	#: "helm-values.acmesolver.image": close({
		digest?:     #."helm-values.acmesolver.image.digest"
		pullPolicy?: #."helm-values.acmesolver.image.pullPolicy"
		registry?:   #."helm-values.acmesolver.image.registry"
		repository?: #."helm-values.acmesolver.image.repository"
		tag?:        #."helm-values.acmesolver.image.tag"
	})

	// Setting a digest will override any tag.
	#: "helm-values.acmesolver.image.digest": string

	// Kubernetes imagePullPolicy on Deployment.
	#: "helm-values.acmesolver.image.pullPolicy": string

	// The container registry to pull the acmesolver image from.
	#: "helm-values.acmesolver.image.registry": string

	// The container image for the cert-manager acmesolver.
	#: "helm-values.acmesolver.image.repository": string

	// Override the image tag to deploy by setting this variable. If no value is
	// set, the chart's appVersion is used.
	#: "helm-values.acmesolver.image.tag": string

	// A Kubernetes Affinity, if required. For more information, see [Affinity v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).
	//
	// For example:
	// affinity:
	// nodeAffinity:
	// requiredDuringSchedulingIgnoredDuringExecution:
	// nodeSelectorTerms:
	// - matchExpressions:
	// - key: foo.bar.com/role
	// operator: In
	// values:
	// - master
	#: "helm-values.affinity": {
		...
	}

	// List of signer names that cert-manager will approve by default.
	// CertificateRequests referencing these signer names will be auto-approved by
	// cert-manager. Defaults to just approving the cert-manager.io Issuer and
	// ClusterIssuer issuers. When set to an empty array, ALL issuers will be
	// auto-approved by cert-manager. To disable the auto-approval, because eg. you
	// are using approver-policy, you can enable 'disableAutoApproval'.
	// ref: https://cert-manager.io/docs/concepts/certificaterequest/#approval
	#: "helm-values.approveSignerNames": [...]

	// Automounting API credentials for a particular pod.
	#: "helm-values.automountServiceAccountToken": bool

	#: "helm-values.cainjector": close({
		affinity?:                     #."helm-values.cainjector.affinity"
		automountServiceAccountToken?: #."helm-values.cainjector.automountServiceAccountToken"
		config?:                       #."helm-values.cainjector.config"
		containerSecurityContext?:     #."helm-values.cainjector.containerSecurityContext"
		deploymentAnnotations?:        #."helm-values.cainjector.deploymentAnnotations"
		enableServiceLinks?:           #."helm-values.cainjector.enableServiceLinks"
		enabled?:                      #."helm-values.cainjector.enabled"
		extraArgs?:                    #."helm-values.cainjector.extraArgs"
		extraEnv?:                     #."helm-values.cainjector.extraEnv"
		featureGates?:                 #."helm-values.cainjector.featureGates"
		image?:                        #."helm-values.cainjector.image"
		nodeSelector?:                 #."helm-values.cainjector.nodeSelector"
		podAnnotations?:               #."helm-values.cainjector.podAnnotations"
		podDisruptionBudget?:          #."helm-values.cainjector.podDisruptionBudget"
		podLabels?:                    #."helm-values.cainjector.podLabels"
		replicaCount?:                 #."helm-values.cainjector.replicaCount"
		resources?:                    #."helm-values.cainjector.resources"
		securityContext?:              #."helm-values.cainjector.securityContext"
		serviceAccount?:               #."helm-values.cainjector.serviceAccount"
		serviceAnnotations?:           #."helm-values.cainjector.serviceAnnotations"
		serviceLabels?:                #."helm-values.cainjector.serviceLabels"
		strategy?:                     #."helm-values.cainjector.strategy"
		tolerations?:                  #."helm-values.cainjector.tolerations"
		topologySpreadConstraints?:    #."helm-values.cainjector.topologySpreadConstraints"
		volumeMounts?:                 #."helm-values.cainjector.volumeMounts"
		volumes?:                      #."helm-values.cainjector.volumes"
	})

	// A Kubernetes Affinity, if required. For more information, see [Affinity v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).
	//
	// For example:
	// affinity:
	// nodeAffinity:
	// requiredDuringSchedulingIgnoredDuringExecution:
	// nodeSelectorTerms:
	// - matchExpressions:
	// - key: foo.bar.com/role
	// operator: In
	// values:
	// - master
	#: "helm-values.cainjector.affinity": {
		...
	}

	// Automounting API credentials for a particular pod.
	#: "helm-values.cainjector.automountServiceAccountToken": bool

	// This is used to configure options for the cainjector pod. It allows setting
	// options that are usually provided via flags.
	//
	// If `apiVersion` and `kind` are unspecified they default to the current latest
	// version (currently `cainjector.config.cert-manager.io/v1alpha1`). You can
	// pin the version by specifying the `apiVersion` yourself.
	//
	// For example:
	// apiVersion: cainjector.config.cert-manager.io/v1alpha1
	// kind: CAInjectorConfiguration
	// logging:
	// verbosity: 2
	// format: text
	// leaderElectionConfig:
	// namespace: kube-system
	// # Configure the metrics server for TLS
	// # See https://cert-manager.io/docs/devops-tips/prometheus-metrics/#tls
	// metricsTLSConfig:
	// dynamic:
	// secretNamespace: "cert-manager"
	// secretName: "cert-manager-metrics-ca"
	// dnsNames:
	// - cert-manager-metrics
	#: "helm-values.cainjector.config": {
		...
	}

	// Container Security Context to be set on the cainjector component container.
	// For more information, see [Configure a Security Context for a Pod or
	// Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	#: "helm-values.cainjector.containerSecurityContext": {
		...
	}

	// Optional additional annotations to add to the cainjector Deployment.
	#: "helm-values.cainjector.deploymentAnnotations": {
		...
	}

	// enableServiceLinks indicates whether information about services should be
	// injected into the pod's environment variables, matching the syntax of Docker
	// links.
	#: "helm-values.cainjector.enableServiceLinks": bool

	// Create the CA Injector deployment
	#: "helm-values.cainjector.enabled": bool

	// Additional command line flags to pass to cert-manager cainjector binary. To
	// see all available flags run `docker run
	// quay.io/jetstack/cert-manager-cainjector:<version> --help`.
	#: "helm-values.cainjector.extraArgs": [...]

	// Additional environment variables to pass to cert-manager cainjector binary.
	// For example:
	// extraEnv:
	// - name: SOME_VAR
	// value: 'some value'
	#: "helm-values.cainjector.extraEnv": [...]

	// Comma separated list of feature gates that should be enabled on the cainjector pod.
	#: "helm-values.cainjector.featureGates": string

	#: "helm-values.cainjector.image": close({
		digest?:     #."helm-values.cainjector.image.digest"
		pullPolicy?: #."helm-values.cainjector.image.pullPolicy"
		registry?:   #."helm-values.cainjector.image.registry"
		repository?: #."helm-values.cainjector.image.repository"
		tag?:        #."helm-values.cainjector.image.tag"
	})

	// Setting a digest will override any tag.
	#: "helm-values.cainjector.image.digest": string

	// Kubernetes imagePullPolicy on Deployment.
	#: "helm-values.cainjector.image.pullPolicy": string

	// The container registry to pull the cainjector image from.
	#: "helm-values.cainjector.image.registry": string

	// The container image for the cert-manager cainjector
	#: "helm-values.cainjector.image.repository": string

	// Override the image tag to deploy by setting this variable. If no value is
	// set, the chart's appVersion will be used.
	#: "helm-values.cainjector.image.tag": string

	// The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with
	// matching labels. For more information, see [Assigning Pods to
	// Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
	//
	// This default ensures that Pods are only scheduled to Linux nodes. It prevents
	// Pods being scheduled to Windows nodes in a mixed OS cluster.
	#: "helm-values.cainjector.nodeSelector": {
		...
	}

	// Optional additional annotations to add to the cainjector Pods.
	#: "helm-values.cainjector.podAnnotations": {
		...
	}

	#: "helm-values.cainjector.podDisruptionBudget": close({
		enabled?:        #."helm-values.cainjector.podDisruptionBudget.enabled"
		maxUnavailable?: #."helm-values.cainjector.podDisruptionBudget.maxUnavailable"
		minAvailable?:   #."helm-values.cainjector.podDisruptionBudget.minAvailable"
	})

	// Enable or disable the PodDisruptionBudget resource.
	//
	// This prevents downtime during voluntary disruptions such as during a Node
	// upgrade. For example, the PodDisruptionBudget will block `kubectl drain` if
	// it is used on the Node where the only remaining cert-manager
	// Pod is currently running.
	#: "helm-values.cainjector.podDisruptionBudget.enabled": bool

	// `maxUnavailable` configures the maximum unavailable pods for disruptions. It can either be set to
	// an integer (e.g. 1) or a percentage value (e.g. 25%).
	// Cannot be used if `minAvailable` is set.
	#: "helm-values.cainjector.podDisruptionBudget.maxUnavailable": _

	// `minAvailable` configures the minimum available pods for disruptions. It can either be set to
	// an integer (e.g. 1) or a percentage value (e.g. 25%).
	// Cannot be used if `maxUnavailable` is set.
	#: "helm-values.cainjector.podDisruptionBudget.minAvailable": _

	// Optional additional labels to add to the CA Injector Pods.
	#: "helm-values.cainjector.podLabels": {
		...
	}

	// The number of replicas of the cert-manager cainjector to run.
	//
	// The default is 1, but in production set this to 2 or 3 to provide high availability.
	//
	// If `replicas > 1`, consider setting `cainjector.podDisruptionBudget.enabled=true`.
	//
	// Note that cert-manager uses leader election to ensure that there can only be
	// a single instance active at a time.
	#: "helm-values.cainjector.replicaCount": number

	// Resources to provide to the cert-manager cainjector pod.
	//
	// For example:
	// requests:
	// cpu: 10m
	// memory: 32Mi
	// For more information, see [Resource Management for Pods and
	// Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
	#: "helm-values.cainjector.resources": {
		...
	}

	// Pod Security Context to be set on the cainjector component Pod. For more
	// information, see [Configure a Security Context for a Pod or
	// Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	#: "helm-values.cainjector.securityContext": {
		...
	}

	#: "helm-values.cainjector.serviceAccount": close({
		annotations?:                  #."helm-values.cainjector.serviceAccount.annotations"
		automountServiceAccountToken?: #."helm-values.cainjector.serviceAccount.automountServiceAccountToken"
		create?:                       #."helm-values.cainjector.serviceAccount.create"
		labels?:                       #."helm-values.cainjector.serviceAccount.labels"
		name?:                         #."helm-values.cainjector.serviceAccount.name"
	})

	// Optional additional annotations to add to the cainjector's Service Account.
	#: "helm-values.cainjector.serviceAccount.annotations": {
		...
	}

	// Automount API credentials for a Service Account.
	#: "helm-values.cainjector.serviceAccount.automountServiceAccountToken": bool

	// Specifies whether a service account should be created.
	#: "helm-values.cainjector.serviceAccount.create": bool

	// Optional additional labels to add to the cainjector's Service Account.
	#: "helm-values.cainjector.serviceAccount.labels": {
		...
	}

	// The name of the service account to use.
	// If not set and create is true, a name is generated using the fullname template
	#: "helm-values.cainjector.serviceAccount.name": string

	// Optional additional annotations to add to the cainjector metrics Service.
	#: "helm-values.cainjector.serviceAnnotations": {
		...
	}

	// Optional additional labels to add to the CA Injector metrics Service.
	#: "helm-values.cainjector.serviceLabels": {
		...
	}

	// Deployment update strategy for the cert-manager cainjector deployment. For
	// more information, see the [Kubernetes
	// documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).
	//
	// For example:
	// strategy:
	// type: RollingUpdate
	// rollingUpdate:
	// maxSurge: 0
	// maxUnavailable: 1
	#: "helm-values.cainjector.strategy": {
		...
	}

	// A list of Kubernetes Tolerations, if required. For more information, see
	// [Toleration v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).
	//
	// For example:
	// tolerations:
	// - key: foo.bar.com/role
	// operator: Equal
	// value: master
	// effect: NoSchedule
	#: "helm-values.cainjector.tolerations": [...]

	// A list of Kubernetes TopologySpreadConstraints, if required. For more
	// information, see [Topology spread constraint v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#topologyspreadconstraint-v1-core).
	//
	// For example:
	// topologySpreadConstraints:
	// - maxSkew: 2
	// topologyKey: topology.kubernetes.io/zone
	// whenUnsatisfiable: ScheduleAnyway
	// labelSelector:
	// matchLabels:
	// app.kubernetes.io/instance: cert-manager
	// app.kubernetes.io/component: controller
	#: "helm-values.cainjector.topologySpreadConstraints": [...]

	// Additional volume mounts to add to the cert-manager controller container.
	#: "helm-values.cainjector.volumeMounts": [...]

	// Additional volumes to add to the cert-manager controller pod.
	#: "helm-values.cainjector.volumes": [...]

	// Override the namespace used to store DNS provider credentials etc. for
	// ClusterIssuer resources. By default, the same namespace as cert-manager is
	// deployed within is used. This namespace will not be automatically created by
	// the Helm chart.
	#: "helm-values.clusterResourceNamespace": string

	// This property is used to configure options for the controller pod. This
	// allows setting options that would usually be provided using flags.
	//
	// If `apiVersion` and `kind` are unspecified they default to the current latest
	// version (currently `controller.config.cert-manager.io/v1alpha1`). You can
	// pin the version by specifying the `apiVersion` yourself.
	//
	// For example:
	// config:
	// apiVersion: controller.config.cert-manager.io/v1alpha1
	// kind: ControllerConfiguration
	// logging:
	// verbosity: 2
	// format: text
	// leaderElectionConfig:
	// namespace: kube-system
	// kubernetesAPIQPS: 9000
	// kubernetesAPIBurst: 9000
	// numberOfConcurrentWorkers: 200
	// enableGatewayAPI: true
	// # Feature gates as of v1.17.0. Listed with their default values.
	// # See https://cert-manager.io/docs/cli/controller/
	// featureGates:
	// AdditionalCertificateOutputFormats: true # BETA - default=true
	// AllAlpha: false # ALPHA - default=false
	// AllBeta: false # BETA - default=false
	// ExperimentalCertificateSigningRequestControllers: false # ALPHA - default=false
	// ExperimentalGatewayAPISupport: true # BETA - default=true
	// LiteralCertificateSubject: true # BETA - default=true
	// NameConstraints: true # BETA - default=true
	// OtherNames: false # ALPHA - default=false
	// SecretsFilteredCaching: true # BETA - default=true
	// ServerSideApply: false # ALPHA - default=false
	// StableCertificateRequestName: true # BETA - default=true
	// UseCertificateRequestBasicConstraints: false # ALPHA - default=false
	// UseDomainQualifiedFinalizer: true # BETA - default=false
	// ValidateCAA: false # ALPHA - default=false
	// # Configure the metrics server for TLS
	// # See https://cert-manager.io/docs/devops-tips/prometheus-metrics/#tls
	// metricsTLSConfig:
	// dynamic:
	// secretNamespace: "cert-manager"
	// secretName: "cert-manager-metrics-ca"
	// dnsNames:
	// - cert-manager-metrics
	#: "helm-values.config": {
		...
	}

	// Container Security Context to be set on the controller component container.
	// For more information, see [Configure a Security Context for a Pod or
	// Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	#: "helm-values.containerSecurityContext": {
		...
	}

	#: "helm-values.crds": close({
		enabled?: #."helm-values.crds.enabled"
		keep?:    #."helm-values.crds.keep"
	})

	// This option decides if the CRDs should be installed as part of the Helm installation.
	#: "helm-values.crds.enabled": bool

	// This option makes it so that the "helm.sh/resource-policy": keep annotation
	// is added to the CRD. This will prevent Helm from uninstalling the CRD when
	// the Helm release is uninstalled. WARNING: when the CRDs are removed, all
	// cert-manager custom resources
	// (Certificates, Issuers, ...) will be removed too by the garbage collector.
	#: "helm-values.crds.keep": bool

	// Field used by our release pipeline to produce the static manifests. The field
	// defaults to "helm" but is set to "static" when we render the static YAML
	// manifests.
	#: "helm-values.creator": string

	// Optional additional annotations to add to the controller Deployment.
	#: "helm-values.deploymentAnnotations": {
		...
	}

	// Option to disable cert-manager's build-in auto-approver. The auto-approver
	// approves all CertificateRequests that reference issuers matching the
	// 'approveSignerNames' option. This 'disableAutoApproval' option is useful
	// when you want to make all approval decisions using a different approver
	// (like approver-policy - https://github.com/cert-manager/approver-policy).
	#: "helm-values.disableAutoApproval": bool

	// A comma-separated string with the host and port of the recursive nameservers
	// cert-manager should query.
	#: "helm-values.dns01RecursiveNameservers": string

	// Forces cert-manager to use only the recursive nameservers for verification.
	// Enabling this option could cause the DNS01 self check to take longer owing
	// to caching performed by the recursive nameservers.
	#: "helm-values.dns01RecursiveNameserversOnly": bool

	// When this flag is enabled, secrets will be automatically removed when the
	// certificate resource is deleted.
	#: "helm-values.enableCertificateOwnerRef": bool

	// enableServiceLinks indicates whether information about services should be
	// injected into the pod's environment variables, matching the syntax of Docker
	// links.
	#: "helm-values.enableServiceLinks": bool

	// Field that can be used as a condition when cert-manager is a dependency. This
	// definition is only here as a placeholder such that it is included in the
	// json schema. See
	// https://helm.sh/docs/chart_best_practices/dependencies/#conditions-and-tags
	// for more info.
	#: "helm-values.enabled": bool

	// Additional command line flags to pass to cert-manager controller binary. To
	// see all available flags run `docker run
	// quay.io/jetstack/cert-manager-controller:<version> --help`.
	//
	// Use this flag to enable or disable arbitrary controllers. For example, to
	// disable the CertificateRequests approver.
	//
	// For example:
	// extraArgs:
	// - --controllers=*,-certificaterequests-approver
	#: "helm-values.extraArgs": [...]

	// Additional environment variables to pass to cert-manager controller binary.
	// For example:
	// extraEnv:
	// - name: SOME_VAR
	// value: 'some value'
	#: "helm-values.extraEnv": [...]

	// Create dynamic manifests via values.
	//
	// For example:
	// extraObjects:
	// - |
	// apiVersion: v1
	// kind: ConfigMap
	// metadata:
	// name: '{{ template "cert-manager.fullname" . }}-extra-configmap'
	#: "helm-values.extraObjects": [...]

	// A comma-separated list of feature gates that should be enabled on the controller pod.
	#: "helm-values.featureGates": string

	// Override the "cert-manager.fullname" value. This value is used as part of
	// most of the names of the resources created by this Helm chart.
	#: "helm-values.fullnameOverride": string

	// Global values shared across all (sub)charts
	#: "helm-values.global": {
		commonLabels?:         #."helm-values.global.commonLabels"
		imagePullSecrets?:     #."helm-values.global.imagePullSecrets"
		leaderElection?:       #."helm-values.global.leaderElection"
		logLevel?:             #."helm-values.global.logLevel"
		podSecurityPolicy?:    #."helm-values.global.podSecurityPolicy"
		priorityClassName?:    #."helm-values.global.priorityClassName"
		rbac?:                 #."helm-values.global.rbac"
		revisionHistoryLimit?: #."helm-values.global.revisionHistoryLimit"
		...
	}

	// Labels to apply to all resources.
	// Please note that this does not add labels to the resources created
	// dynamically by the controllers. For these resources, you have to add the
	// labels in the template in the cert-manager custom resource: For example,
	// podTemplate/ ingressTemplate in ACMEChallengeSolverHTTP01Ingress. For more
	// information, see the [cert-manager
	// documentation](https://cert-manager.io/docs/reference/api-docs/#acme.cert-manager.io/v1.ACMEChallengeSolverHTTP01Ingress).
	// For example, secretTemplate in CertificateSpec
	// For more information, see the [cert-manager
	// documentation](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.CertificateSpec).
	#: "helm-values.global.commonLabels": {
		...
	}

	// Reference to one or more secrets to be used when pulling images. For more
	// information, see [Pull an Image from a Private
	// Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).
	//
	// For example:
	// imagePullSecrets:
	// - name: "image-pull-secret"
	#: "helm-values.global.imagePullSecrets": [...]

	#: "helm-values.global.leaderElection": {
		leaseDuration?: #."helm-values.global.leaderElection.leaseDuration"
		namespace?:     #."helm-values.global.leaderElection.namespace"
		renewDeadline?: #."helm-values.global.leaderElection.renewDeadline"
		retryPeriod?:   #."helm-values.global.leaderElection.retryPeriod"
		...
	}

	// The duration that non-leader candidates will wait after observing a
	// leadership renewal until attempting to acquire leadership of a led but
	// unrenewed leader slot. This is effectively the maximum duration that a
	// leader can be stopped before it is replaced by another candidate.
	#: "helm-values.global.leaderElection.leaseDuration": string

	// Override the namespace used for the leader election lease.
	#: "helm-values.global.leaderElection.namespace": string

	// The interval between attempts by the acting master to renew a leadership slot
	// before it stops leading. This must be less than or equal to the lease
	// duration.
	#: "helm-values.global.leaderElection.renewDeadline": string

	// The duration the clients should wait between attempting acquisition and renewal of a leadership.
	#: "helm-values.global.leaderElection.retryPeriod": string

	// Set the verbosity of cert-manager. A range of 0 - 6, with 6 being the most verbose.
	#: "helm-values.global.logLevel": number

	#: "helm-values.global.podSecurityPolicy": {
		enabled?:     #."helm-values.global.podSecurityPolicy.enabled"
		useAppArmor?: #."helm-values.global.podSecurityPolicy.useAppArmor"
		...
	}

	// Create PodSecurityPolicy for cert-manager.
	//
	// Note that PodSecurityPolicy was deprecated in Kubernetes 1.21 and removed in Kubernetes 1.25.
	#: "helm-values.global.podSecurityPolicy.enabled": bool

	// Configure the PodSecurityPolicy to use AppArmor.
	#: "helm-values.global.podSecurityPolicy.useAppArmor": bool

	// The optional priority class to be used for the cert-manager pods.
	#: "helm-values.global.priorityClassName": string

	#: "helm-values.global.rbac": {
		aggregateClusterRoles?: #."helm-values.global.rbac.aggregateClusterRoles"
		create?:                #."helm-values.global.rbac.create"
		...
	}

	// Aggregate ClusterRoles to Kubernetes default user-facing roles. For more
	// information, see [User-facing
	// roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles)
	#: "helm-values.global.rbac.aggregateClusterRoles": bool

	// Create required ClusterRoles and ClusterRoleBindings for cert-manager.
	#: "helm-values.global.rbac.create": bool

	// The number of old ReplicaSets to retain to allow rollback (if not set, the
	// default Kubernetes value is set to 10).
	#: "helm-values.global.revisionHistoryLimit": number

	// Optional hostAliases for cert-manager-controller pods. May be useful when
	// performing ACME DNS-01 self checks.
	#: "helm-values.hostAliases": [...]

	// Configures the HTTP_PROXY environment variable where a HTTP proxy is required.
	#: "helm-values.http_proxy": string

	// Configures the HTTPS_PROXY environment variable where a HTTP proxy is required.
	#: "helm-values.https_proxy": string

	#: "helm-values.image": close({
		digest?:     #."helm-values.image.digest"
		pullPolicy?: #."helm-values.image.pullPolicy"
		registry?:   #."helm-values.image.registry"
		repository?: #."helm-values.image.repository"
		tag?:        #."helm-values.image.tag"
	})

	// Setting a digest will override any tag.
	#: "helm-values.image.digest": string

	// Kubernetes imagePullPolicy on Deployment.
	#: "helm-values.image.pullPolicy": string

	// The container registry to pull the manager image from.
	#: "helm-values.image.registry": string

	// The container image for the cert-manager controller.
	#: "helm-values.image.repository": string

	// Override the image tag to deploy by setting this variable. If no value is
	// set, the chart's appVersion is used.
	#: "helm-values.image.tag": string

	#: "helm-values.ingressShim": close({
		defaultIssuerGroup?: #."helm-values.ingressShim.defaultIssuerGroup"
		defaultIssuerKind?:  #."helm-values.ingressShim.defaultIssuerKind"
		defaultIssuerName?:  #."helm-values.ingressShim.defaultIssuerName"
	})

	// Optional default issuer group to use for ingress resources.
	#: "helm-values.ingressShim.defaultIssuerGroup": string

	// Optional default issuer kind to use for ingress resources.
	#: "helm-values.ingressShim.defaultIssuerKind": string

	// Optional default issuer to use for ingress resources.
	#: "helm-values.ingressShim.defaultIssuerName": string

	// This option is equivalent to setting crds.enabled=true and crds.keep=true.
	// Deprecated: use crds.enabled and crds.keep instead.
	#: "helm-values.installCRDs": bool

	// LivenessProbe settings for the controller container of the controller Pod.
	//
	// This is enabled by default, in order to enable the clock-skew liveness probe
	// that restarts the controller in case of a skew between the system clock and
	// the monotonic clock. LivenessProbe durations and thresholds are based on
	// those used for the Kubernetes controller-manager. For more information see
	// the following on the
	// [Kubernetes GitHub
	// repository](https://github.com/kubernetes/kubernetes/blob/806b30170c61a38fedd54cc9ede4cd6275a1ad3b/cmd/kubeadm/app/util/staticpod/utils.go#L241-L245)
	#: "helm-values.livenessProbe": {
		...
	}

	// The maximum number of challenges that can be scheduled as 'processing' at once.
	#: "helm-values.maxConcurrentChallenges": number

	// Override the "cert-manager.name" value, which is used to annotate some of the
	// resources that are created by this Chart (using "app.kubernetes.io/name").
	// NOTE: There are some inconsistencies in the Helm chart when it comes to
	// these annotations (some resources use eg. "cainjector.name" which resolves
	// to the value "cainjector").
	#: "helm-values.nameOverride": string

	// This namespace allows you to define where the services are installed into. If
	// not set then they use the namespace of the release. This is helpful when
	// installing cert manager as a chart dependency (sub chart).
	#: "helm-values.namespace": string

	// Configures the NO_PROXY environment variable where a HTTP proxy is required,
	// but certain domains should be excluded.
	#: "helm-values.no_proxy": string

	// The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with
	// matching labels. For more information, see [Assigning Pods to
	// Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
	//
	// This default ensures that Pods are only scheduled to Linux nodes. It prevents
	// Pods being scheduled to Windows nodes in a mixed OS cluster.
	#: "helm-values.nodeSelector": {
		...
	}

	// Optional additional annotations to add to the controller Pods.
	#: "helm-values.podAnnotations": {
		...
	}

	#: "helm-values.podDisruptionBudget": close({
		enabled?:        #."helm-values.podDisruptionBudget.enabled"
		maxUnavailable?: #."helm-values.podDisruptionBudget.maxUnavailable"
		minAvailable?:   #."helm-values.podDisruptionBudget.minAvailable"
	})

	// Enable or disable the PodDisruptionBudget resource.
	//
	// This prevents downtime during voluntary disruptions such as during a Node
	// upgrade. For example, the PodDisruptionBudget will block `kubectl drain` if
	// it is used on the Node where the only remaining cert-manager
	// Pod is currently running.
	#: "helm-values.podDisruptionBudget.enabled": bool

	// This configures the maximum unavailable pods for disruptions. It can either
	// be set to an integer (e.g. 1) or a percentage value (e.g. 25%). it cannot be
	// used if `minAvailable` is set.
	#: "helm-values.podDisruptionBudget.maxUnavailable": _

	// This configures the minimum available pods for disruptions. It can either be
	// set to an integer (e.g. 1) or a percentage value (e.g. 25%).
	// It cannot be used if `maxUnavailable` is set.
	#: "helm-values.podDisruptionBudget.minAvailable": _

	// Pod DNS configuration. The podDnsConfig field is optional and can work with
	// any podDnsPolicy settings. However, when a Pod's dnsPolicy is set to "None",
	// the dnsConfig field has to be specified. For more information, see [Pod's
	// DNS
	// Config](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config).
	#: "helm-values.podDnsConfig": {
		...
	}

	// Pod DNS policy.
	// For more information, see [Pod's DNS
	// Policy](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy).
	#: "helm-values.podDnsPolicy": string

	// Optional additional labels to add to the controller Pods.
	#: "helm-values.podLabels": {
		...
	}

	#: "helm-values.prometheus": close({
		enabled?:        #."helm-values.prometheus.enabled"
		podmonitor?:     #."helm-values.prometheus.podmonitor"
		servicemonitor?: #."helm-values.prometheus.servicemonitor"
	})

	// Enable Prometheus monitoring for the cert-manager controller and webhook. If
	// you use the Prometheus Operator, set prometheus.podmonitor.enabled or
	// prometheus.servicemonitor.enabled, to create a PodMonitor or a
	// ServiceMonitor resource.
	// Otherwise, 'prometheus.io' annotations are added to the cert-manager and
	// cert-manager-webhook Deployments. Note that you can not enable both
	// PodMonitor and ServiceMonitor as they are mutually exclusive. Enabling both
	// will result in an error.
	#: "helm-values.prometheus.enabled": bool

	#: "helm-values.prometheus.podmonitor": close({
		annotations?:                  #."helm-values.prometheus.podmonitor.annotations"
		enabled?:                      #."helm-values.prometheus.podmonitor.enabled"
		endpointAdditionalProperties?: #."helm-values.prometheus.podmonitor.endpointAdditionalProperties"
		honorLabels?:                  #."helm-values.prometheus.podmonitor.honorLabels"
		interval?:                     #."helm-values.prometheus.podmonitor.interval"
		labels?:                       #."helm-values.prometheus.podmonitor.labels"
		namespace?:                    #."helm-values.prometheus.podmonitor.namespace"
		path?:                         #."helm-values.prometheus.podmonitor.path"
		prometheusInstance?:           #."helm-values.prometheus.podmonitor.prometheusInstance"
		scrapeTimeout?:                #."helm-values.prometheus.podmonitor.scrapeTimeout"
	})

	// Additional annotations to add to the PodMonitor.
	#: "helm-values.prometheus.podmonitor.annotations": {
		...
	}

	// Create a PodMonitor to add cert-manager to Prometheus.
	#: "helm-values.prometheus.podmonitor.enabled": bool

	// EndpointAdditionalProperties allows setting additional properties on the
	// endpoint such as relabelings, metricRelabelings etc.
	//
	// For example:
	// endpointAdditionalProperties:
	// relabelings:
	// - action: replace
	// sourceLabels:
	// - __meta_kubernetes_pod_node_name
	// targetLabel: instance
	// # Configure the PodMonitor for TLS connections
	// # See https://cert-manager.io/docs/devops-tips/prometheus-metrics/#tls
	// scheme: https
	// tlsConfig:
	// serverName: cert-manager-metrics
	// ca:
	// secret:
	// name: cert-manager-metrics-ca
	// key: "tls.crt"
	#: "helm-values.prometheus.podmonitor.endpointAdditionalProperties": {
		...
	}

	// Keep labels from scraped data, overriding server-side labels.
	#: "helm-values.prometheus.podmonitor.honorLabels": bool

	// The interval to scrape metrics.
	#: "helm-values.prometheus.podmonitor.interval": string

	// Additional labels to add to the PodMonitor.
	#: "helm-values.prometheus.podmonitor.labels": {
		...
	}

	// The namespace that the pod monitor should live in, defaults to the cert-manager namespace.
	#: "helm-values.prometheus.podmonitor.namespace": string

	// The path to scrape for metrics.
	#: "helm-values.prometheus.podmonitor.path": string

	// Specifies the `prometheus` label on the created PodMonitor. This is used when
	// different Prometheus instances have label selectors matching different
	// PodMonitors.
	#: "helm-values.prometheus.podmonitor.prometheusInstance": string

	// The timeout before a metrics scrape fails.
	#: "helm-values.prometheus.podmonitor.scrapeTimeout": string

	#: "helm-values.prometheus.servicemonitor": close({
		annotations?:                  #."helm-values.prometheus.servicemonitor.annotations"
		enabled?:                      #."helm-values.prometheus.servicemonitor.enabled"
		endpointAdditionalProperties?: #."helm-values.prometheus.servicemonitor.endpointAdditionalProperties"
		honorLabels?:                  #."helm-values.prometheus.servicemonitor.honorLabels"
		interval?:                     #."helm-values.prometheus.servicemonitor.interval"
		labels?:                       #."helm-values.prometheus.servicemonitor.labels"
		namespace?:                    #."helm-values.prometheus.servicemonitor.namespace"
		path?:                         #."helm-values.prometheus.servicemonitor.path"
		prometheusInstance?:           #."helm-values.prometheus.servicemonitor.prometheusInstance"
		scrapeTimeout?:                #."helm-values.prometheus.servicemonitor.scrapeTimeout"
		targetPort?:                   #."helm-values.prometheus.servicemonitor.targetPort"
	})

	// Additional annotations to add to the ServiceMonitor.
	#: "helm-values.prometheus.servicemonitor.annotations": {
		...
	}

	// Create a ServiceMonitor to add cert-manager to Prometheus.
	#: "helm-values.prometheus.servicemonitor.enabled": bool

	// EndpointAdditionalProperties allows setting additional properties on the
	// endpoint such as relabelings, metricRelabelings etc.
	//
	// For example:
	// endpointAdditionalProperties:
	// relabelings:
	// - action: replace
	// sourceLabels:
	// - __meta_kubernetes_pod_node_name
	// targetLabel: instance
	#: "helm-values.prometheus.servicemonitor.endpointAdditionalProperties": {
		...
	}

	// Keep labels from scraped data, overriding server-side labels.
	#: "helm-values.prometheus.servicemonitor.honorLabels": bool

	// The interval to scrape metrics.
	#: "helm-values.prometheus.servicemonitor.interval": string

	// Additional labels to add to the ServiceMonitor.
	#: "helm-values.prometheus.servicemonitor.labels": {
		...
	}

	// The namespace that the service monitor should live in, defaults to the cert-manager namespace.
	#: "helm-values.prometheus.servicemonitor.namespace": string

	// The path to scrape for metrics.
	#: "helm-values.prometheus.servicemonitor.path": string

	// Specifies the `prometheus` label on the created ServiceMonitor. This is used
	// when different Prometheus instances have label selectors matching different
	// ServiceMonitors.
	#: "helm-values.prometheus.servicemonitor.prometheusInstance": string

	// The timeout before a metrics scrape fails.
	#: "helm-values.prometheus.servicemonitor.scrapeTimeout": string

	// The target port to set on the ServiceMonitor. This must match the port that
	// the cert-manager controller is listening on for metrics.
	#: "helm-values.prometheus.servicemonitor.targetPort": number

	// The number of replicas of the cert-manager controller to run.
	//
	// The default is 1, but in production set this to 2 or 3 to provide high availability.
	//
	// If `replicas > 1`, consider setting `podDisruptionBudget.enabled=true`.
	//
	// Note that cert-manager uses leader election to ensure that there can only be
	// a single instance active at a time.
	#: "helm-values.replicaCount": number

	// Resources to provide to the cert-manager controller pod.
	//
	// For example:
	// requests:
	// cpu: 10m
	// memory: 32Mi
	// For more information, see [Resource Management for Pods and
	// Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
	#: "helm-values.resources": {
		...
	}

	// Pod Security Context.
	// For more information, see [Configure a Security Context for a Pod or
	// Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	#: "helm-values.securityContext": {
		...
	}

	#: "helm-values.serviceAccount": close({
		annotations?:                  #."helm-values.serviceAccount.annotations"
		automountServiceAccountToken?: #."helm-values.serviceAccount.automountServiceAccountToken"
		create?:                       #."helm-values.serviceAccount.create"
		labels?:                       #."helm-values.serviceAccount.labels"
		name?:                         #."helm-values.serviceAccount.name"
	})

	// Optional additional annotations to add to the controller's Service Account.
	// Templates are allowed for both keys and values.
	// Example using templating:
	// annotations:
	// "{{ .Chart.Name }}-helm-chart/version": "{{ .Chart.Version }}"
	#: "helm-values.serviceAccount.annotations": {
		...
	}

	// Automount API credentials for a Service Account.
	#: "helm-values.serviceAccount.automountServiceAccountToken": bool

	// Specifies whether a service account should be created.
	#: "helm-values.serviceAccount.create": bool

	// Optional additional labels to add to the controller's Service Account.
	#: "helm-values.serviceAccount.labels": {
		...
	}

	// The name of the service account to use.
	// If not set and create is true, a name is generated using the fullname template.
	#: "helm-values.serviceAccount.name": string

	// Optional annotations to add to the controller Service.
	#: "helm-values.serviceAnnotations": {
		...
	}

	// Optionally set the IP families for the controller Service that should be
	// supported, in the order in which they should be applied to ClusterIP. Can be
	// IPv4 and/or IPv6.
	#: "helm-values.serviceIPFamilies": [...]

	// Optionally set the IP family policy for the controller Service to configure
	// dual-stack; see [Configure
	// dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack/#services).
	#: "helm-values.serviceIPFamilyPolicy": string

	// Optional additional labels to add to the controller Service.
	#: "helm-values.serviceLabels": {
		...
	}

	#: "helm-values.startupapicheck": close({
		affinity?:                     #."helm-values.startupapicheck.affinity"
		automountServiceAccountToken?: #."helm-values.startupapicheck.automountServiceAccountToken"
		backoffLimit?:                 #."helm-values.startupapicheck.backoffLimit"
		containerSecurityContext?:     #."helm-values.startupapicheck.containerSecurityContext"
		enableServiceLinks?:           #."helm-values.startupapicheck.enableServiceLinks"
		enabled?:                      #."helm-values.startupapicheck.enabled"
		extraArgs?:                    #."helm-values.startupapicheck.extraArgs"
		extraEnv?:                     #."helm-values.startupapicheck.extraEnv"
		image?:                        #."helm-values.startupapicheck.image"
		jobAnnotations?:               #."helm-values.startupapicheck.jobAnnotations"
		nodeSelector?:                 #."helm-values.startupapicheck.nodeSelector"
		podAnnotations?:               #."helm-values.startupapicheck.podAnnotations"
		podLabels?:                    #."helm-values.startupapicheck.podLabels"
		rbac?:                         #."helm-values.startupapicheck.rbac"
		resources?:                    #."helm-values.startupapicheck.resources"
		securityContext?:              #."helm-values.startupapicheck.securityContext"
		serviceAccount?:               #."helm-values.startupapicheck.serviceAccount"
		timeout?:                      #."helm-values.startupapicheck.timeout"
		tolerations?:                  #."helm-values.startupapicheck.tolerations"
		volumeMounts?:                 #."helm-values.startupapicheck.volumeMounts"
		volumes?:                      #."helm-values.startupapicheck.volumes"
	})

	// A Kubernetes Affinity, if required. For more information, see [Affinity v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).
	// For example:
	// affinity:
	// nodeAffinity:
	// requiredDuringSchedulingIgnoredDuringExecution:
	// nodeSelectorTerms:
	// - matchExpressions:
	// - key: foo.bar.com/role
	// operator: In
	// values:
	// - master
	#: "helm-values.startupapicheck.affinity": {
		...
	}

	// Automounting API credentials for a particular pod.
	#: "helm-values.startupapicheck.automountServiceAccountToken": bool

	// Job backoffLimit
	#: "helm-values.startupapicheck.backoffLimit": number

	// Container Security Context to be set on the controller component container.
	// For more information, see [Configure a Security Context for a Pod or
	// Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	#: "helm-values.startupapicheck.containerSecurityContext": {
		...
	}

	// enableServiceLinks indicates whether information about services should be
	// injected into pod's environment variables, matching the syntax of Docker
	// links.
	#: "helm-values.startupapicheck.enableServiceLinks": bool

	// Enables the startup api check.
	#: "helm-values.startupapicheck.enabled": bool

	// Additional command line flags to pass to startupapicheck binary. To see all
	// available flags run `docker run
	// quay.io/jetstack/cert-manager-startupapicheck:<version> --help`.
	//
	// Verbose logging is enabled by default so that if startupapicheck fails, you
	// can know what exactly caused the failure. Verbose logs include details of
	// the webhook URL, IP address and TCP connect errors for example.
	#: "helm-values.startupapicheck.extraArgs": [...]

	// Additional environment variables to pass to cert-manager startupapicheck binary.
	// For example:
	// extraEnv:
	// - name: SOME_VAR
	// value: 'some value'
	#: "helm-values.startupapicheck.extraEnv": [...]

	#: "helm-values.startupapicheck.image": close({
		digest?:     #."helm-values.startupapicheck.image.digest"
		pullPolicy?: #."helm-values.startupapicheck.image.pullPolicy"
		registry?:   #."helm-values.startupapicheck.image.registry"
		repository?: #."helm-values.startupapicheck.image.repository"
		tag?:        #."helm-values.startupapicheck.image.tag"
	})

	// Setting a digest will override any tag.
	#: "helm-values.startupapicheck.image.digest": string

	// Kubernetes imagePullPolicy on Deployment.
	#: "helm-values.startupapicheck.image.pullPolicy": string

	// The container registry to pull the startupapicheck image from.
	#: "helm-values.startupapicheck.image.registry": string

	// The container image for the cert-manager startupapicheck.
	#: "helm-values.startupapicheck.image.repository": string

	// Override the image tag to deploy by setting this variable. If no value is
	// set, the chart's appVersion is used.
	#: "helm-values.startupapicheck.image.tag": string

	// Optional additional annotations to add to the startupapicheck Job.
	#: "helm-values.startupapicheck.jobAnnotations": {
		...
	}

	// The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with
	// matching labels. For more information, see [Assigning Pods to
	// Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
	//
	// This default ensures that Pods are only scheduled to Linux nodes. It prevents
	// Pods being scheduled to Windows nodes in a mixed OS cluster.
	#: "helm-values.startupapicheck.nodeSelector": {
		...
	}

	// Optional additional annotations to add to the startupapicheck Pods.
	#: "helm-values.startupapicheck.podAnnotations": {
		...
	}

	// Optional additional labels to add to the startupapicheck Pods.
	#: "helm-values.startupapicheck.podLabels": {
		...
	}

	#: "helm-values.startupapicheck.rbac": close({
		annotations?: #."helm-values.startupapicheck.rbac.annotations"
	})

	// annotations for the startup API Check job RBAC and PSP resources.
	#: "helm-values.startupapicheck.rbac.annotations": {
		...
	}

	// Resources to provide to the cert-manager controller pod.
	//
	// For example:
	// requests:
	// cpu: 10m
	// memory: 32Mi
	// For more information, see [Resource Management for Pods and
	// Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
	#: "helm-values.startupapicheck.resources": {
		...
	}

	// Pod Security Context to be set on the startupapicheck component Pod. For more
	// information, see [Configure a Security Context for a Pod or
	// Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	#: "helm-values.startupapicheck.securityContext": {
		...
	}

	#: "helm-values.startupapicheck.serviceAccount": close({
		annotations?:                  #."helm-values.startupapicheck.serviceAccount.annotations"
		automountServiceAccountToken?: #."helm-values.startupapicheck.serviceAccount.automountServiceAccountToken"
		create?:                       #."helm-values.startupapicheck.serviceAccount.create"
		labels?:                       #."helm-values.startupapicheck.serviceAccount.labels"
		name?:                         #."helm-values.startupapicheck.serviceAccount.name"
	})

	// Optional additional annotations to add to the Job's Service Account.
	#: "helm-values.startupapicheck.serviceAccount.annotations": {
		...
	}

	// Automount API credentials for a Service Account.
	#: "helm-values.startupapicheck.serviceAccount.automountServiceAccountToken": bool

	// Specifies whether a service account should be created.
	#: "helm-values.startupapicheck.serviceAccount.create": bool

	// Optional additional labels to add to the startupapicheck's Service Account.
	#: "helm-values.startupapicheck.serviceAccount.labels": {
		...
	}

	// The name of the service account to use.
	// If not set and create is true, a name is generated using the fullname template.
	#: "helm-values.startupapicheck.serviceAccount.name": string

	// Timeout for 'kubectl check api' command.
	#: "helm-values.startupapicheck.timeout": string

	// A list of Kubernetes Tolerations, if required. For more information, see
	// [Toleration v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).
	//
	// For example:
	// tolerations:
	// - key: foo.bar.com/role
	// operator: Equal
	// value: master
	// effect: NoSchedule
	#: "helm-values.startupapicheck.tolerations": [...]

	// Additional volume mounts to add to the cert-manager controller container.
	#: "helm-values.startupapicheck.volumeMounts": [...]

	// Additional volumes to add to the cert-manager controller pod.
	#: "helm-values.startupapicheck.volumes": [...]

	// Deployment update strategy for the cert-manager controller deployment. For
	// more information, see the [Kubernetes
	// documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).
	//
	// For example:
	// strategy:
	// type: RollingUpdate
	// rollingUpdate:
	// maxSurge: 0
	// maxUnavailable: 1
	#: "helm-values.strategy": {
		...
	}

	// A list of Kubernetes Tolerations, if required. For more information, see
	// [Toleration v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).
	//
	// For example:
	// tolerations:
	// - key: foo.bar.com/role
	// operator: Equal
	// value: master
	// effect: NoSchedule
	#: "helm-values.tolerations": [...]

	// A list of Kubernetes TopologySpreadConstraints, if required. For more
	// information, see [Topology spread constraint v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#topologyspreadconstraint-v1-core
	//
	// For example:
	// topologySpreadConstraints:
	// - maxSkew: 2
	// topologyKey: topology.kubernetes.io/zone
	// whenUnsatisfiable: ScheduleAnyway
	// labelSelector:
	// matchLabels:
	// app.kubernetes.io/instance: cert-manager
	// app.kubernetes.io/component: controller
	#: "helm-values.topologySpreadConstraints": [...]

	// Additional volume mounts to add to the cert-manager controller container.
	#: "helm-values.volumeMounts": [...]

	// Additional volumes to add to the cert-manager controller pod.
	#: "helm-values.volumes": [...]

	#: "helm-values.webhook": close({
		affinity?:                                  #."helm-values.webhook.affinity"
		automountServiceAccountToken?:              #."helm-values.webhook.automountServiceAccountToken"
		config?:                                    #."helm-values.webhook.config"
		containerSecurityContext?:                  #."helm-values.webhook.containerSecurityContext"
		deploymentAnnotations?:                     #."helm-values.webhook.deploymentAnnotations"
		enableServiceLinks?:                        #."helm-values.webhook.enableServiceLinks"
		extraArgs?:                                 #."helm-values.webhook.extraArgs"
		extraEnv?:                                  #."helm-values.webhook.extraEnv"
		featureGates?:                              #."helm-values.webhook.featureGates"
		hostNetwork?:                               #."helm-values.webhook.hostNetwork"
		image?:                                     #."helm-values.webhook.image"
		livenessProbe?:                             #."helm-values.webhook.livenessProbe"
		loadBalancerIP?:                            #."helm-values.webhook.loadBalancerIP"
		mutatingWebhookConfiguration?:              #."helm-values.webhook.mutatingWebhookConfiguration"
		mutatingWebhookConfigurationAnnotations?:   #."helm-values.webhook.mutatingWebhookConfigurationAnnotations"
		networkPolicy?:                             #."helm-values.webhook.networkPolicy"
		nodeSelector?:                              #."helm-values.webhook.nodeSelector"
		podAnnotations?:                            #."helm-values.webhook.podAnnotations"
		podDisruptionBudget?:                       #."helm-values.webhook.podDisruptionBudget"
		podLabels?:                                 #."helm-values.webhook.podLabels"
		readinessProbe?:                            #."helm-values.webhook.readinessProbe"
		replicaCount?:                              #."helm-values.webhook.replicaCount"
		resources?:                                 #."helm-values.webhook.resources"
		securePort?:                                #."helm-values.webhook.securePort"
		securityContext?:                           #."helm-values.webhook.securityContext"
		serviceAccount?:                            #."helm-values.webhook.serviceAccount"
		serviceAnnotations?:                        #."helm-values.webhook.serviceAnnotations"
		serviceIPFamilies?:                         #."helm-values.webhook.serviceIPFamilies"
		serviceIPFamilyPolicy?:                     #."helm-values.webhook.serviceIPFamilyPolicy"
		serviceLabels?:                             #."helm-values.webhook.serviceLabels"
		serviceType?:                               #."helm-values.webhook.serviceType"
		strategy?:                                  #."helm-values.webhook.strategy"
		timeoutSeconds?:                            #."helm-values.webhook.timeoutSeconds"
		tolerations?:                               #."helm-values.webhook.tolerations"
		topologySpreadConstraints?:                 #."helm-values.webhook.topologySpreadConstraints"
		url?:                                       #."helm-values.webhook.url"
		validatingWebhookConfiguration?:            #."helm-values.webhook.validatingWebhookConfiguration"
		validatingWebhookConfigurationAnnotations?: #."helm-values.webhook.validatingWebhookConfigurationAnnotations"
		volumeMounts?:                              #."helm-values.webhook.volumeMounts"
		volumes?:                                   #."helm-values.webhook.volumes"
	})

	// A Kubernetes Affinity, if required. For more information, see [Affinity v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).
	//
	// For example:
	// affinity:
	// nodeAffinity:
	// requiredDuringSchedulingIgnoredDuringExecution:
	// nodeSelectorTerms:
	// - matchExpressions:
	// - key: foo.bar.com/role
	// operator: In
	// values:
	// - master
	#: "helm-values.webhook.affinity": {
		...
	}

	// Automounting API credentials for a particular pod.
	#: "helm-values.webhook.automountServiceAccountToken": bool

	// This is used to configure options for the webhook pod. This allows setting
	// options that would usually be provided using flags.
	//
	// If `apiVersion` and `kind` are unspecified they default to the current latest
	// version (currently `webhook.config.cert-manager.io/v1alpha1`). You can pin
	// the version by specifying the `apiVersion` yourself.
	//
	// For example:
	// apiVersion: webhook.config.cert-manager.io/v1alpha1
	// kind: WebhookConfiguration
	// # The port that the webhook listens on for requests.
	// # In GKE private clusters, by default Kubernetes apiservers are allowed to
	// # talk to the cluster nodes only on 443 and 10250. Configuring
	// # securePort: 10250 therefore will work out-of-the-box without needing to add firewall
	// # rules or requiring NET_BIND_SERVICE capabilities to bind port numbers < 1000.
	// # This should be uncommented and set as a default by the chart once
	// # the apiVersion of WebhookConfiguration graduates beyond v1alpha1.
	// securePort: 10250
	// # Configure the metrics server for TLS
	// # See https://cert-manager.io/docs/devops-tips/prometheus-metrics/#tls
	// metricsTLSConfig:
	// dynamic:
	// secretNamespace: "cert-manager"
	// secretName: "cert-manager-metrics-ca"
	// dnsNames:
	// - cert-manager-metrics
	#: "helm-values.webhook.config": {
		...
	}

	// Container Security Context to be set on the webhook component container. For
	// more information, see [Configure a Security Context for a Pod or
	// Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	#: "helm-values.webhook.containerSecurityContext": {
		...
	}

	// Optional additional annotations to add to the webhook Deployment.
	#: "helm-values.webhook.deploymentAnnotations": {
		...
	}

	// enableServiceLinks indicates whether information about services should be
	// injected into the pod's environment variables, matching the syntax of Docker
	// links.
	#: "helm-values.webhook.enableServiceLinks": bool

	// Additional command line flags to pass to cert-manager webhook binary. To see
	// all available flags run `docker run
	// quay.io/jetstack/cert-manager-webhook:<version> --help`.
	#: "helm-values.webhook.extraArgs": [...]

	// Additional environment variables to pass to cert-manager webhook binary.
	// For example:
	// extraEnv:
	// - name: SOME_VAR
	// value: 'some value'
	#: "helm-values.webhook.extraEnv": [...]

	// Comma separated list of feature gates that should be enabled on the webhook pod.
	#: "helm-values.webhook.featureGates": string

	// Specifies if the webhook should be started in hostNetwork mode.
	//
	// Required for use in some managed kubernetes clusters (such as AWS EKS) with
	// custom. CNI (such as calico), because control-plane managed by AWS cannot
	// communicate with pods' IP CIDR and admission webhooks are not working
	//
	// Since the default port for the webhook conflicts with kubelet on the host
	// network, `webhook.securePort` should be changed to an available port if
	// running in hostNetwork mode.
	#: "helm-values.webhook.hostNetwork": bool

	#: "helm-values.webhook.image": close({
		digest?:     #."helm-values.webhook.image.digest"
		pullPolicy?: #."helm-values.webhook.image.pullPolicy"
		registry?:   #."helm-values.webhook.image.registry"
		repository?: #."helm-values.webhook.image.repository"
		tag?:        #."helm-values.webhook.image.tag"
	})

	// Setting a digest will override any tag
	#: "helm-values.webhook.image.digest": string

	// Kubernetes imagePullPolicy on Deployment.
	#: "helm-values.webhook.image.pullPolicy": string

	// The container registry to pull the webhook image from.
	#: "helm-values.webhook.image.registry": string

	// The container image for the cert-manager webhook
	#: "helm-values.webhook.image.repository": string

	// Override the image tag to deploy by setting this variable. If no value is
	// set, the chart's appVersion will be used.
	#: "helm-values.webhook.image.tag": string

	// Liveness probe values.
	// For more information, see [Container
	// probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes).
	#: "helm-values.webhook.livenessProbe": {
		...
	}

	// Specify the load balancer IP for the created service.
	#: "helm-values.webhook.loadBalancerIP": string

	#: "helm-values.webhook.mutatingWebhookConfiguration": close({
		namespaceSelector?: #."helm-values.webhook.mutatingWebhookConfiguration.namespaceSelector"
	})

	// Configure spec.namespaceSelector for mutating webhooks.
	#: "helm-values.webhook.mutatingWebhookConfiguration.namespaceSelector": {
		...
	}

	// Optional additional annotations to add to the webhook MutatingWebhookConfiguration.
	#: "helm-values.webhook.mutatingWebhookConfigurationAnnotations": {
		...
	}

	#: "helm-values.webhook.networkPolicy": close({
		egress?:  #."helm-values.webhook.networkPolicy.egress"
		enabled?: #."helm-values.webhook.networkPolicy.enabled"
		ingress?: #."helm-values.webhook.networkPolicy.ingress"
	})

	// Egress rule for the webhook network policy. By default, it allows all
	// outbound traffic to ports 80 and 443, as well as DNS ports.
	#: "helm-values.webhook.networkPolicy.egress": [...]

	// Create network policies for the webhooks.
	#: "helm-values.webhook.networkPolicy.enabled": bool

	// Ingress rule for the webhook network policy. By default, it allows all inbound traffic.
	#: "helm-values.webhook.networkPolicy.ingress": [...]

	// The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with
	// matching labels. For more information, see [Assigning Pods to
	// Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
	//
	// This default ensures that Pods are only scheduled to Linux nodes. It prevents
	// Pods being scheduled to Windows nodes in a mixed OS cluster.
	#: "helm-values.webhook.nodeSelector": {
		...
	}

	// Optional additional annotations to add to the webhook Pods.
	#: "helm-values.webhook.podAnnotations": {
		...
	}

	#: "helm-values.webhook.podDisruptionBudget": close({
		enabled?:        #."helm-values.webhook.podDisruptionBudget.enabled"
		maxUnavailable?: #."helm-values.webhook.podDisruptionBudget.maxUnavailable"
		minAvailable?:   #."helm-values.webhook.podDisruptionBudget.minAvailable"
	})

	// Enable or disable the PodDisruptionBudget resource.
	//
	// This prevents downtime during voluntary disruptions such as during a Node
	// upgrade. For example, the PodDisruptionBudget will block `kubectl drain` if
	// it is used on the Node where the only remaining cert-manager
	// Pod is currently running.
	#: "helm-values.webhook.podDisruptionBudget.enabled": bool

	// This property configures the maximum unavailable pods for disruptions. Can
	// either be set to an integer (e.g. 1) or a percentage value (e.g. 25%).
	// It cannot be used if `minAvailable` is set.
	#: "helm-values.webhook.podDisruptionBudget.maxUnavailable": _

	// This property configures the minimum available pods for disruptions. Can
	// either be set to an integer (e.g. 1) or a percentage value (e.g. 25%).
	// It cannot be used if `maxUnavailable` is set.
	#: "helm-values.webhook.podDisruptionBudget.minAvailable": _

	// Optional additional labels to add to the Webhook Pods.
	#: "helm-values.webhook.podLabels": {
		...
	}

	// Readiness probe values.
	// For more information, see [Container
	// probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes).
	#: "helm-values.webhook.readinessProbe": {
		...
	}

	// Number of replicas of the cert-manager webhook to run.
	//
	// The default is 1, but in production set this to 2 or 3 to provide high availability.
	//
	// If `replicas > 1`, consider setting `webhook.podDisruptionBudget.enabled=true`.
	#: "helm-values.webhook.replicaCount": number

	// Resources to provide to the cert-manager webhook pod.
	//
	// For example:
	// requests:
	// cpu: 10m
	// memory: 32Mi
	// For more information, see [Resource Management for Pods and
	// Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
	#: "helm-values.webhook.resources": {
		...
	}

	// The port that the webhook listens on for requests. In GKE private clusters,
	// by default Kubernetes apiservers are allowed to talk to the cluster nodes
	// only on 443 and 10250. Configuring securePort: 10250, therefore will work
	// out-of-the-box without needing to add firewall rules or requiring
	// NET_BIND_SERVICE capabilities to bind port numbers <1000.
	#: "helm-values.webhook.securePort": number

	// Pod Security Context to be set on the webhook component Pod. For more
	// information, see [Configure a Security Context for a Pod or
	// Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	#: "helm-values.webhook.securityContext": {
		...
	}

	#: "helm-values.webhook.serviceAccount": close({
		annotations?:                  #."helm-values.webhook.serviceAccount.annotations"
		automountServiceAccountToken?: #."helm-values.webhook.serviceAccount.automountServiceAccountToken"
		create?:                       #."helm-values.webhook.serviceAccount.create"
		labels?:                       #."helm-values.webhook.serviceAccount.labels"
		name?:                         #."helm-values.webhook.serviceAccount.name"
	})

	// Optional additional annotations to add to the webhook's Service Account.
	#: "helm-values.webhook.serviceAccount.annotations": {
		...
	}

	// Automount API credentials for a Service Account.
	#: "helm-values.webhook.serviceAccount.automountServiceAccountToken": bool

	// Specifies whether a service account should be created.
	#: "helm-values.webhook.serviceAccount.create": bool

	// Optional additional labels to add to the webhook's Service Account.
	#: "helm-values.webhook.serviceAccount.labels": {
		...
	}

	// The name of the service account to use.
	// If not set and create is true, a name is generated using the fullname template.
	#: "helm-values.webhook.serviceAccount.name": string

	// Optional additional annotations to add to the webhook Service.
	#: "helm-values.webhook.serviceAnnotations": {
		...
	}

	// Optionally set the IP families for the controller Service that should be
	// supported, in the order in which they should be applied to ClusterIP. Can be
	// IPv4 and/or IPv6.
	#: "helm-values.webhook.serviceIPFamilies": [...]

	// Optionally set the IP family policy for the controller Service to configure
	// dual-stack; see [Configure
	// dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack/#services).
	#: "helm-values.webhook.serviceIPFamilyPolicy": string

	// Optional additional labels to add to the Webhook Service.
	#: "helm-values.webhook.serviceLabels": {
		...
	}

	// Specifies how the service should be handled. Useful if you want to expose the
	// webhook outside of the cluster. In some cases, the control plane cannot
	// reach internal services.
	#: "helm-values.webhook.serviceType": string

	// The update strategy for the cert-manager webhook deployment. For more
	// information, see the [Kubernetes
	// documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy)
	//
	// For example:
	// strategy:
	// type: RollingUpdate
	// rollingUpdate:
	// maxSurge: 0
	// maxUnavailable: 1
	#: "helm-values.webhook.strategy": {
		...
	}

	// The number of seconds the API server should wait for the webhook to respond
	// before treating the call as a failure. The value must be between 1 and 30
	// seconds. For more information, see
	// [Validating webhook configuration
	// v1](https://kubernetes.io/docs/reference/kubernetes-api/extend-resources/validating-webhook-configuration-v1/).
	//
	// The default is set to the maximum value of 30 seconds as users sometimes
	// report that the connection between the K8S API server and the cert-manager
	// webhook server times out. If *this* timeout is reached, the error message
	// will be "context deadline exceeded", which doesn't help the user diagnose
	// what phase of the HTTPS connection timed out. For example, it could be
	// during DNS resolution, TCP connection, TLS negotiation, HTTP negotiation, or
	// slow HTTP response from the webhook server. By setting this timeout to its
	// maximum value the underlying timeout error message has more chance of being
	// returned to the end user.
	#: "helm-values.webhook.timeoutSeconds": number

	// A list of Kubernetes Tolerations, if required. For more information, see
	// [Toleration v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).
	//
	// For example:
	// tolerations:
	// - key: foo.bar.com/role
	// operator: Equal
	// value: master
	// effect: NoSchedule
	#: "helm-values.webhook.tolerations": [...]

	// A list of Kubernetes TopologySpreadConstraints, if required. For more
	// information, see [Topology spread constraint v1
	// core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#topologyspreadconstraint-v1-core).
	//
	// For example:
	// topologySpreadConstraints:
	// - maxSkew: 2
	// topologyKey: topology.kubernetes.io/zone
	// whenUnsatisfiable: ScheduleAnyway
	// labelSelector:
	// matchLabels:
	// app.kubernetes.io/instance: cert-manager
	// app.kubernetes.io/component: controller
	#: "helm-values.webhook.topologySpreadConstraints": [...]

	// Overrides the mutating webhook and validating webhook so they reach the
	// webhook service using the `url` field instead of a service.
	#: "helm-values.webhook.url": {
		...
	}

	#: "helm-values.webhook.validatingWebhookConfiguration": close({
		namespaceSelector?: #."helm-values.webhook.validatingWebhookConfiguration.namespaceSelector"
	})

	// Configure spec.namespaceSelector for validating webhooks.
	#: "helm-values.webhook.validatingWebhookConfiguration.namespaceSelector": {
		...
	}

	// Optional additional annotations to add to the webhook ValidatingWebhookConfiguration.
	#: "helm-values.webhook.validatingWebhookConfigurationAnnotations": {
		...
	}

	// Additional volume mounts to add to the cert-manager controller container.
	#: "helm-values.webhook.volumeMounts": [...]

	// Additional volumes to add to the cert-manager controller pod.
	#: "helm-values.webhook.volumes": [...]
}
