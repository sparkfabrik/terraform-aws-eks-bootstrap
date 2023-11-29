# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2023-11-29

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/1.1.0...1.1.1)

- refs platform/#2586: fix output for `grafana_admin_password` when `enable_kube_prometheus_stack` is `false`.

## [1.1.0] - 2023-11-22

[Compare with previous version](https://github.com/sparkfabrik/terraform-aws-eks-bootstrap/compare/1.0.0...1.1.0)

- refs #000: add link for CloudWatch Observability EKS addon.
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
