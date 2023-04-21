# terraform-aws-eks-bootstrap
<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.63 |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.63 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.19 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_default_region"></a> [aws\_default\_region](#input\_aws\_default\_region) | AWS default region | `string` | n/a | yes |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | n/a | <pre>object({<br>    name                           = string<br>    version                        = optional(string, "1.24")<br>    enable_endpoint_public_access  = optional(bool, true)<br>    enable_endpoint_private_access = optional(bool, true)<br>    log_group_retention_in_days    = optional(number, 14)<br>    enabled_log_types              = optional(list(string), []) # Possible values: "api", "audit", "authenticator", "controllerManager", "scheduler"<br>    eks_managed_node_group_defaults = optional(object({<br>      instance_types = optional(list(string), ["t3.medium"])<br>      disk_size      = optional(number, 50)<br>      desired_size   = optional(number, 2)<br>      labels = optional(map(string), {<br>        role = "default"<br>      })      <br>      }), {<br>      instance_types = ["t3.medium"]<br>      disk_size      = 50<br>      desired_size   = 1<br>      labels = { role = "default" }<br>    })<br>    eks_managed_node_groups = optional(map(object({<br>      min_size       = optional(number, 1)<br>      max_size       = optional(number, 3)<br>      desired_size   = optional(number, 1)<br>      instance_types = optional(list(string), ["t3.small"])<br>      capacity_type  = optional(string, "SPOT")<br>      labels = optional(map(string), {<br>        role = "spot"<br>      })<br>      })), {<br>      default = {<br>        min_size       = 1<br>        max_size       = 3<br>        desired_size   = 1<br>        instance_types = ["t3.small"]<br>        capacity_type  = "SPOT"<br>        labels = { role = "spot" }<br>      }    <br>    })<br>    # Cluster Autoscaler https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler<br>    autoscaler = optional(object({<br>      chart_version     = optional(string, "9.28.0")<br>      namespace         = optional(string, "kube-system")<br>      helm_release_name = optional(string, "cluster-autoscaler")<br>      cpu_threshold     = optional(string, "0.8")<br>      }), {<br>      chart_version     = "9.28.0"<br>      namespace         = "kube-system"<br>      helm_release_name = "cluster-autoscaler"<br>      cpu_threshold     = "0.8"<br>    })<br>    # ALB Ingress Controller https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller<br>    alb_controller = optional(object({<br>      chart_version     = optional(string, "1.5.2")<br>      namespace         = optional(string, "kube-system")<br>      helm_release_name = optional(string, "aws-load-balancer-controller")<br>      }), {<br>      chart_version     = "1.5.2"<br>      namespace         = "kube-system"<br>      helm_release_name = "aws-load-balancer-controller"<br>    })<br>    # Node Termination Handler https://artifacthub.io/packages/helm/aws/aws-node-termination-handler<br>    node_termination_handler = optional(object({<br>      chart_version     = optional(string, "0.21.0")<br>      namespace         = optional(string, "kube-system")<br>      helm_release_name = optional(string, "aws-node-termination-handler")<br>      }), {<br>      chart_version     = "0.21.0"<br>      namespace         = "kube-system"<br>      helm_release_name = "aws-node-termination-handler"<br>    })<br>    cluster_access = optional(object({<br>      enable               = optional(bool, true)<br>      developer_group_name = optional(string, "cluster-developer")<br>      admin_group_name     = optional(string, "cluster-admin")<br>      environment          = optional(string, "prod")<br>      namespaces           = optional(list(string), ["default"])<br>      }), {<br>      enable               = true<br>      developer_group_name = "cluster-developer"<br>      admin_group_name     = "cluster-admin"<br>      environment          = "prod"<br>    })<br>    # Cert Manager https://artifacthub.io/packages/helm/jetstack/cert-manager<br>    cert_manager = optional(object({<br>      chart_version               = optional(string, "1.11.1")<br>      namespace                   = optional(string, "cert-manager")<br>      helm_release_name           = optional(string, "cert-manager")<br>      cluster_issuer_name         = optional(string, "letsencrypt-prod")<br>      secret_name                 = optional(string, "letsencrypt-prod")<br>      staging_cluster_issuer_name = optional(string, "letsencrypt-staging")<br>      staging_secret_name         = optional(string, "letsencrypt-staging")<br>      email                       = optional(string, "example@example.com")<br>      install_cluster_issuer      = optional(bool, true)<br>      }), {<br>      chart_version               = "1.11.1"<br>      namespace                   = "cert-manager"<br>      helm_release_name           = "cert-manager"<br>      cluster_issuer_name         = "letsencrypt-prod"<br>      secret_name                 = "letsencrypt-prod"<br>      staging_cluster_issuer_name = "letsencrypt-staging"<br>      staging_secret_name         = "letsencrypt-staging"<br>      email                       = "example@example.com"<br>      install_cluster_issuer      = true<br>    })<br>    # Metrics Server https://artifacthub.io/packages/helm/metrics-server/metrics-server<br>    metrics_server = optional(object({<br>      chart_version     = optional(string, "3.10.0")<br>      namespace         = optional(string, "metrics-server")<br>      helm_release_name = optional(string, "metrics-server")<br>      }), {<br>      chart_version     = "3.10.0"<br>      namespace         = "metrics-server"<br>      helm_release_name = "metrics-server"<br>    })<br>    ingress_nginx = optional(object({<br>      chart_version     = optional(string, "4.6.0")<br>      namespace         = optional(string, "ingress-nginx")<br>      helm_release_name = optional(string, "ingress-nginx")<br>      aws_tags          = optional(map(string), {})<br>      nlb_name          = optional(string, "ingress-nginx-nlb")<br>      }), {<br>      chart_version     = "3.36.0"<br>      namespace         = "ingress-nginx"<br>      helm_release_name = "ingress-nginx"<br>      aws_tags          = {}<br>    })<br>    fluentbit = optional(object({<br>      fluent_bit_image_tag              = optional(string, "2.21.6")<br>      fluent_bit_enable_logs_collection = optional(bool, false)<br>      fluent_bit_http_server            = optional(string, "Off")<br>      fluent_bit_http_port              = optional(string, "")<br>      fluent_bit_read_from_head         = optional(string, "Off")<br>      fluent_bit_read_from_tail         = optional(string, "On")<br>      fluent_bit_log_retention_days     = optional(number, 14)<br>      namespace                         = optional(string, "amazon-cloudwatch")<br>      }), {<br>      fluent_bit_image_tag              = "1.8.10"<br>      fluent_bit_enable_logs_collection = false<br>      fluent_bit_http_server            = "Off"<br>      fluent_bit_http_port              = ""<br>      fluent_bit_read_from_head         = "Off"<br>      fluent_bit_read_from_tail         = "On"<br>      fluent_bit_log_retention_days     = 14<br>      namespace                         = "amazon-cloudwatch"<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | Arn of cloudwatch log group created |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of cloudwatch log group created |
| <a name="output_cluster_addons"></a> [cluster\_addons](#output\_cluster\_addons) | Map of attribute maps for all EKS cluster addons enabled |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_cluster_iam_role_arn"></a> [cluster\_iam\_role\_arn](#output\_cluster\_iam\_role\_arn) | IAM role ARN of the EKS cluster |
| <a name="output_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#output\_cluster\_iam\_role\_name) | IAM role name of the EKS cluster |
| <a name="output_cluster_iam_role_unique_id"></a> [cluster\_iam\_role\_unique\_id](#output\_cluster\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider |
| <a name="output_cluster_platform_version"></a> [cluster\_platform\_version](#output\_cluster\_platform\_version) | Platform version for the cluster |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console |
| <a name="output_cluster_security_group_arn"></a> [cluster\_security\_group\_arn](#output\_cluster\_security\_group\_arn) | Amazon Resource Name (ARN) of the cluster security group |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | ID of the cluster security group |
| <a name="output_cluster_status"></a> [cluster\_status](#output\_cluster\_status) | Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED` |
| <a name="output_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#output\_eks\_managed\_node\_groups) | Map of attribute maps for all EKS managed node groups created |
| <a name="output_eks_managed_node_groups_autoscaling_group_names"></a> [eks\_managed\_node\_groups\_autoscaling\_group\_names](#output\_eks\_managed\_node\_groups\_autoscaling\_group\_names) | List of the autoscaling group names created by EKS managed node groups |
| <a name="output_node_security_group_arn"></a> [node\_security\_group\_arn](#output\_node\_security\_group\_arn) | Amazon Resource Name (ARN) of the node shared security group |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | ID of the node shared security group |
## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_controller"></a> [alb\_controller](#module\_alb\_controller) | ./modules/alb-controller | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/certificate-manager | n/a |
| <a name="module_cluster_access"></a> [cluster\_access](#module\_cluster\_access) | ./modules/cluster-access | n/a |
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | ./modules/cluster-autoscaler | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 19.13 |
| <a name="module_fluentbit"></a> [fluentbit](#module\_fluentbit) | ./modules/fluentbit | n/a |
| <a name="module_metrics_server"></a> [metrics\_server](#module\_metrics\_server) | ./modules/metrics-server | n/a |
| <a name="module_node_termination_handler"></a> [node\_termination\_handler](#module\_node\_termination\_handler) | ./modules/node-termination-handler | n/a |

<!-- END_TF_DOCS -->