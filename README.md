# Terraform aws eks bootstrap

Bootstrap module for AWS EKS cluster.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.63 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.9 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.14 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.19 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5 |
| <a name="provider_template"></a> [template](#provider\_template) | >= 2.2 |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.63 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.19 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.2 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_users"></a> [admin\_users](#input\_admin\_users) | n/a | `list(any)` | n/a | yes |
| <a name="input_aws_alb_controller_helm_config"></a> [aws\_alb\_controller\_helm\_config](#input\_aws\_alb\_controller\_helm\_config) | AWS Load Balancer Controller Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_aws_ebs_csi_driver_helm_config"></a> [aws\_ebs\_csi\_driver\_helm\_config](#input\_aws\_ebs\_csi\_driver\_helm\_config) | AWS EBS csi driver Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_aws_node_termination_handler_helm_config"></a> [aws\_node\_termination\_handler\_helm\_config](#input\_aws\_node\_termination\_handler\_helm\_config) | Node Termination handler Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_calico_helm_config"></a> [calico\_helm\_config](#input\_calico\_helm\_config) | Calico Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_cert_manager_helm_config"></a> [cert\_manager\_helm\_config](#input\_cert\_manager\_helm\_config) | Cert Manager Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Number of days to retain log events. | `number` | `7` | no |
| <a name="input_cluster_access_admin_groups"></a> [cluster\_access\_admin\_groups](#input\_cluster\_access\_admin\_groups) | The list of groups that will be mapped to the admin role in the application namespaces. | `list(string)` | n/a | yes |
| <a name="input_cluster_access_developer_groups"></a> [cluster\_access\_developer\_groups](#input\_cluster\_access\_developer\_groups) | The list of groups that will be mapped to the developer role in the application namespaces. | `list(string)` | n/a | yes |
| <a name="input_cluster_access_map_users"></a> [cluster\_access\_map\_users](#input\_cluster\_access\_map\_users) | Cluster access | <pre>list(<br>    object({<br>      userarn  = string,<br>      username = string,<br>      groups   = list(string)<br>    })<br>  )</pre> | `[]` | no |
| <a name="input_cluster_additional_addons"></a> [cluster\_additional\_addons](#input\_cluster\_additional\_addons) | Additional addons to install for EKS cluster. | `map(any)` | `{}` | no |
| <a name="input_cluster_autoscaler_helm_config"></a> [cluster\_autoscaler\_helm\_config](#input\_cluster\_autoscaler\_helm\_config) | Cluster Autoscaler Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_cluster_enable_amazon_cloudwatch_observability_addon"></a> [cluster\_enable\_amazon\_cloudwatch\_observability\_addon](#input\_cluster\_enable\_amazon\_cloudwatch\_observability\_addon) | Indicates whether to enable the Amazon CloudWatch Container Insights for Kubernetes. | `bool` | `true` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | A list of the desired control plane logging to enable. For more information, see Amazon EKS Cluster Logging in the Amazon EKS User Guide. | `list(string)` | `[]` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default is true | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default is true | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_iam_role_additional_policies"></a> [cluster\_iam\_role\_additional\_policies](#input\_cluster\_iam\_role\_additional\_policies) | Additional policies to be added to the IAM role. | `map(string)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The Kubernetes version to use for the EKS cluster. | `string` | `"1.24"` | no |
| <a name="input_customer_application"></a> [customer\_application](#input\_customer\_application) | Customer application | <pre>map(object({<br>    namespaces   = list(string)<br>    repositories = optional(list(string), [])<br>  }))</pre> | n/a | yes |
| <a name="input_developer_users"></a> [developer\_users](#input\_developer\_users) | n/a | `list(any)` | n/a | yes |
| <a name="input_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#input\_eks\_managed\_node\_groups) | Cluster node group | `any` | <pre>{<br>  "core_pool": {<br>    "desired_size": 2,<br>    "instance_types": [<br>      "t3.medium"<br>    ],<br>    "labels": {<br>      "Pool": "core"<br>    },<br>    "max_size": 4,<br>    "min_size": 1,<br>    "tags": {<br>      "Pool": "core"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_enable_aws_alb_controller"></a> [enable\_aws\_alb\_controller](#input\_enable\_aws\_alb\_controller) | Enable AWS Load Balancer Controller | `bool` | `false` | no |
| <a name="input_enable_aws_ebs_csi_driver"></a> [enable\_aws\_ebs\_csi\_driver](#input\_enable\_aws\_ebs\_csi\_driver) | Enable AWS EBS CSI Driver | `bool` | `true` | no |
| <a name="input_enable_aws_node_termination_handler"></a> [enable\_aws\_node\_termination\_handler](#input\_enable\_aws\_node\_termination\_handler) | Enable AWS Node Termination Handler | `bool` | `true` | no |
| <a name="input_enable_calico"></a> [enable\_calico](#input\_enable\_calico) | Enable Calico | `bool` | `false` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Enable Cert Manager | `bool` | `true` | no |
| <a name="input_enable_cluster_autoscaler"></a> [enable\_cluster\_autoscaler](#input\_enable\_cluster\_autoscaler) | Enable Cluster Autoscaler | `bool` | `true` | no |
| <a name="input_enable_firestarter_operations"></a> [enable\_firestarter\_operations](#input\_enable\_firestarter\_operations) | Enable Firestarter Operations | `bool` | `false` | no |
| <a name="input_enable_gitlab_runner"></a> [enable\_gitlab\_runner](#input\_enable\_gitlab\_runner) | Enable Gitlab Runner | `bool` | `true` | no |
| <a name="input_enable_ingress_nginx"></a> [enable\_ingress\_nginx](#input\_enable\_ingress\_nginx) | Enable Ingress Nginx | `bool` | `true` | no |
| <a name="input_enable_kube_prometheus_stack"></a> [enable\_kube\_prometheus\_stack](#input\_enable\_kube\_prometheus\_stack) | Enable Kube Prometheus Stack | `bool` | `false` | no |
| <a name="input_enable_metric_server"></a> [enable\_metric\_server](#input\_enable\_metric\_server) | Enable Metric Server | `bool` | `true` | no |
| <a name="input_enable_velero"></a> [enable\_velero](#input\_enable\_velero) | Enable Velero | `bool` | `false` | no |
| <a name="input_enable_velero_bucket_lifecycle"></a> [enable\_velero\_bucket\_lifecycle](#input\_enable\_velero\_bucket\_lifecycle) | Enable Velero Bucket Lifecycle | `bool` | `true` | no |
| <a name="input_enhanced_container_insights_enabled"></a> [enhanced\_container\_insights\_enabled](#input\_enhanced\_container\_insights\_enabled) | Indicates whether to enable the enhanced CloudWatch Container Insights for Kubernetes. | `bool` | `true` | no |
| <a name="input_gitlab_runner_additional_policy_arns"></a> [gitlab\_runner\_additional\_policy\_arns](#input\_gitlab\_runner\_additional\_policy\_arns) | Gitlab Runner Additional Policy ARNs | `list(string)` | `[]` | no |
| <a name="input_gitlab_runner_registration_token"></a> [gitlab\_runner\_registration\_token](#input\_gitlab\_runner\_registration\_token) | Gitlab Runner Registration Token | `string` | n/a | yes |
| <a name="input_gitlab_runner_tags"></a> [gitlab\_runner\_tags](#input\_gitlab\_runner\_tags) | Gitlab Runner Helm Chart Configuration | `list(string)` | <pre>[<br>  "aws"<br>]</pre> | no |
| <a name="input_ingress_nginx_helm_config"></a> [ingress\_nginx\_helm\_config](#input\_ingress\_nginx\_helm\_config) | Ingress Nginx Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_install_letsencrypt_issuers"></a> [install\_letsencrypt\_issuers](#input\_install\_letsencrypt\_issuers) | Install Let's Encrypt Issuers | `bool` | `true` | no |
| <a name="input_kube_prometheus_grafana_hostname"></a> [kube\_prometheus\_grafana\_hostname](#input\_kube\_prometheus\_grafana\_hostname) | n/a | `string` | `""` | no |
| <a name="input_kube_prometheus_storage_zone"></a> [kube\_prometheus\_storage\_zone](#input\_kube\_prometheus\_storage\_zone) | n/a | `list(string)` | `[]` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email address for expiration emails from Let's Encrypt. | `string` | `"example@example.com"` | no |
| <a name="input_metric_server_helm_config"></a> [metric\_server\_helm\_config](#input\_metric\_server\_helm\_config) | Metric Server Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_prometheus_stack_additional_values"></a> [prometheus\_stack\_additional\_values](#input\_prometheus\_stack\_additional\_values) | Additional values for Kube Prometheus Stack | `list(string)` | `[]` | no |
| <a name="input_velero_bucket_expiration_days"></a> [velero\_bucket\_expiration\_days](#input\_velero\_bucket\_expiration\_days) | n/a | `number` | `90` | no |
| <a name="input_velero_bucket_glacier_days"></a> [velero\_bucket\_glacier\_days](#input\_velero\_bucket\_glacier\_days) | n/a | `number` | `60` | no |
| <a name="input_velero_bucket_infrequently_access_days"></a> [velero\_bucket\_infrequently\_access\_days](#input\_velero\_bucket\_infrequently\_access\_days) | n/a | `number` | `30` | no |
| <a name="input_velero_helm_config"></a> [velero\_helm\_config](#input\_velero\_helm\_config) | Velero Helm Chart Configuration | `any` | `{}` | no |
| <a name="input_velero_helm_values"></a> [velero\_helm\_values](#input\_velero\_helm\_values) | Velero helm chart values | `string` | `""` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_eks_cluster_auth_token"></a> [aws\_eks\_cluster\_auth\_token](#output\_aws\_eks\_cluster\_auth\_token) | n/a |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | n/a |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_customer_application_ecr_repository"></a> [customer\_application\_ecr\_repository](#output\_customer\_application\_ecr\_repository) | n/a |
| <a name="output_customer_application_namespaces"></a> [customer\_application\_namespaces](#output\_customer\_application\_namespaces) | n/a |
| <a name="output_grafana_admin_password"></a> [grafana\_admin\_password](#output\_grafana\_admin\_password) | # Grafana password |
| <a name="output_ingress_nginx_dns_name"></a> [ingress\_nginx\_dns\_name](#output\_ingress\_nginx\_dns\_name) | n/a |
| <a name="output_ingress_nginx_zone_id"></a> [ingress\_nginx\_zone\_id](#output\_ingress\_nginx\_zone\_id) | n/a |
## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_policy.aws_ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_s3_bucket.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_public_access_block.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [helm_release.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.aws_node_termination_handler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.calico](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ebs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metric_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.velero](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.cert_manager_cluster_issuer](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.ebs_storageclass](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.aws_ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.aws_node_termination_handler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.calico](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.customer_application](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.metric_server](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.velero](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_id.resources_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_lb.ingress_nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.velero_default_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_ebs_csi_driver_identity"></a> [aws\_ebs\_csi\_driver\_identity](#module\_aws\_ebs\_csi\_driver\_identity) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> 4.2 |
| <a name="module_cluster_access"></a> [cluster\_access](#module\_cluster\_access) | github.com/sparkfabrik/terraform-kubernetes-cluster-access | 0.1.0 |
| <a name="module_cluster_autoscaler_irsa_role"></a> [cluster\_autoscaler\_irsa\_role](#module\_cluster\_autoscaler\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.17 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 19.13 |
| <a name="module_firestarter_operations"></a> [firestarter\_operations](#module\_firestarter\_operations) | ./modules/firestarter-operations | n/a |
| <a name="module_gitlab_runner"></a> [gitlab\_runner](#module\_gitlab\_runner) | github.com/sparkfabrik/terraform-aws-eks-gitlab-runner | 4e020f8 |
| <a name="module_ingress_nginx"></a> [ingress\_nginx](#module\_ingress\_nginx) | github.com/sparkfabrik/terraform-helm-ingress-nginx | 0.4.0 |
| <a name="module_kube_prometheus_stack"></a> [kube\_prometheus\_stack](#module\_kube\_prometheus\_stack) | github.com/sparkfabrik/terraform-sparkfabrik-prometheus-stack | 3.0.0 |
| <a name="module_load_balancer_controller_irsa_role"></a> [load\_balancer\_controller\_irsa\_role](#module\_load\_balancer\_controller\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.17 |
| <a name="module_node_termination_handler_irsa_role"></a> [node\_termination\_handler\_irsa\_role](#module\_node\_termination\_handler\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.17 |
| <a name="module_velero_irsa_role"></a> [velero\_irsa\_role](#module\_velero\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.20 |

<!-- END_TF_DOCS -->
