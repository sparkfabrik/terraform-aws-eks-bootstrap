# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.3.0] - 2025-04-04

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/4.2.0...4.3.0)

### Updated

- Update module `aws_s3_bucket_lifecycle_configuration` parameters

## [4.2.0] - 2025-03-25

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/4.1.0...4.2.0)

### Added

- refs platform/#3519: Update Ingress Nginx module to version `0.8.0`

## [4.1.0] - 2025-02-28

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/4.0.0...4.1.0)

### Added

- Update github.com/sparkfabrik/terraform-helm-fluentbit module to version 0.4.0
- Add a new output `managed_node_group_iam_roles` to expose a map of IAM roles for all managed node groups created

## [4.0.0] - 2024-12-5

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/3.0.0...4.0.0)

### Added

- refs platform/#3267: Update modules for compatibility with aws-eks 1.25

### ⚠️ Breaking changes ⚠️

**ATTENTION:** read the [upgrading instructions](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/blob/4.0.0/UPGRADING.md#from-3x-to-400).

## [3.1.0] - 2024-07-09

### Added

- refs platform/#2819: add documentation about patching the EKS cluster add-ons.
- refs #000: refactor of the EKS cluster add-ons code.
- Fix EKS addon
- Add Fluntbit

## [3.0.0] - 2023-12-21

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/2.1.0...3.0.0)

### ⚠️ Breaking changes ⚠️

**ATTENTION:** read the [upgrading instructions](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/blob/3.0.0/UPGRADING.md#upgrading-from-2xy-to-300).

### Changed

- refs platform/#2564: update nginx-ingress controller installation module, using the module hosted on [GitHub](https://github.com/sparkfabrik/terraform-helm-ingress-nginx/).

## [2.1.0] - 2023-12-04

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/2.0.0...2.1.0)

### Changed

- refs platform/#2586: the `enhanced_container_insights_enabled` variable is now true by default.

## [2.0.0] - 2023-11-30

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/1.2.0...2.0.0)

### ⚠️ Breaking changes ⚠️

**ATTENTION:** before applying these changes you must follow the [upgrading instructions](https://github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack#upgrading-from-2xy-to-300) for the Prometheus Stack module.

### Changed

- refs platform/#2586: update Prometheus Stack module to version `3.0.0` to support multiple values configuration for the Kube Prometheus Stack.

## [1.2.0] - 2023-11-30

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/1.1.1...1.2.0)

### Added

- refs platform/#2586: add `enhanced_container_insights_enabled` variable to enable/disable enhanced container insights for CloudWatch. Remember that this feature only allows to use **the last 3 hours of collected metrics**. You can find more information about limitations [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch-metrics-insights-limits.html).

## [1.1.1] - 2023-11-29

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/1.1.0...1.1.1)

### Changed

- refs platform/#2586: fix output for `grafana_admin_password` when `enable_kube_prometheus_stack` is `false`.

## [1.1.0] - 2023-11-22

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/1.0.0...1.1.0)

### Added

- refs #000: add link for CloudWatch Observability EKS addon.

### Changed

- refs platform/#2560: remove local module cluster access and use the one from [GitHub](https://github.com/sparkfabrik/terraform-kubernetes-cluster-access).

## [1.0.0] - 2023-11-22

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/0.3.0...1.0.0)

### ⚠️ Breaking changes ⚠️

**ATTENTION:** before applying these changes you must manually remove the `amazon-cloudwatch` namespace from your cluster. If you have deployed other stuffs, at least you have to remove the fluent-bit reosources (`ConfigMaps` and `DaemonSets`). You have to remove these resources from the terraform state too. If you want to keep the fluent-bit installation, please turn off the `cluster_enable_amazon_cloudwatch_observability_addon` variable and remove the flutn-bit resources from the terraform state.

### Added

- [refs #33](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/issues/33): add `cluster_enable_amazon_cloudwatch_observability_addon` variable to enable Amazon CloudWatch Container Insights for Kubernetes.

### Changed

- [refs #33](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/issues/33): remove standalone flunt-bit installation.

## [0.3.0] - 2023-11-22

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/0.2.0...0.3.0)

### Added

- refs #000: add `cluster_additional_addons` variable to manage additional EKS addons.
- refs #000: add `cluster_iam_role_additional_policies` variable to manage additional IAM policy attachments for cluster role.

## [0.2.0] - 2023-08-25

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/0.1.0...0.2.0)

### Changed

- refs #24 Add Velero by @osvaldot in https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/pull/25
- refs #0000 Add Kube Prometheus Stack by @osvaldot in https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/pull/26
- Configure Renovate by @renovate in https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/pull/27

## [0.1.0] - 2023-05-09

- Init project.
