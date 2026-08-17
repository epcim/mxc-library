// vim: set ts=2 sw=2 et :
package velero

import "github.com/epcim/mxc/schema"

#Velero: S=schema.#App & {
	_flavor: {
		nano: {
			values: resources: {
				limits: { memory: "256Mi" }
				requests: { cpu: "10m", memory: "64Mi" }
			}
			values: nodeAgent: resources: {
				limits: { memory: "256Mi" }
				requests: { cpu: "10m", memory: "64Mi" }
			}
		}
		small: {
			values: resources: {
				limits: { memory: "256Mi" }
				requests: { cpu: "10m", memory: "64Mi" }
			}
			values: nodeAgent: resources: {
				limits: { memory: "256Mi" }
				requests: { cpu: "10m", memory: "64Mi" }
			}
		}
		medium: {
			values: resources: {
				limits: { memory: "512Mi" }
				requests: { cpu: "50m", memory: "128Mi" }
			}
			values: nodeAgent: resources: {
				limits: { memory: "512Mi" }
				requests: { cpu: "50m", memory: "128Mi" }
			}
		}
	}

	appName:    "velero"
	deployment: "kluctl"
	helmChart: {
		repo:         "https://vmware-tanzu.github.io/helm-charts"
		chartName:    "velero"
		chartVersion: "8.2.0"
		releaseName:  "velero"
		namespace:    kustomize.namespace
		skipCRDs:     false
		skipPrePull:  true
	}
	kustomize: {
		namespace: "velero"
		labels: [{
			includeSelectors: true
			pairs: {
				app: "velero"
			}
		}]
		resources: [
			"helm-rendered.yaml",
		]
	}
	
	flavor: string | *"small"

	// schema: .chart-schema/values.yaml
	values: {
		initContainers?: [...{}] | *[
			{
				name: "velero-plugin-for-aws"
				image: "velero/velero-plugin-for-aws:v1.11.1"
				imagePullPolicy: "IfNotPresent"
				volumeMounts: [
					{
						mountPath: "/target"
						name: "plugins"
					}
				]
			}
		]
		deployNodeAgent: bool | *true
		credentials: {
			useSecret?: bool | *true
			secretContents: {
				[string]: string
				cloud: *"""
					[default]
					aws_access_key_id={{ secrets.velero.accessKey }}
					aws_secret_access_key={{ secrets.velero.secretKey }}
					""" | string
			}
		}
		configuration: {
			backupStorageLocation: [...{
				name: string
				provider: string
				bucket: string
				default?: bool
				config?: [string]: string
			}] | *[
				{
					name:     "synology"
					provider: "aws"
					bucket:   "velero"
					default:  true
					config: {
						region:           "minio"
						s3ForcePathStyle: "true"
						s3Url:            "{{ secrets.velero.s3Url }}"
					}
				}
			]
			volumeSnapshotLocation: [...{
				name: string
				provider: string
				config?: [string]: string
			}] | *[
				{
					name:     "default"
					provider: "aws"
					config: {
						region: "minio"
					}
				}
			]
		}
		schedules?: [string]: _
	}

	tags: ["infra", "velero"]
	
	_flavor[S.flavor]
}
