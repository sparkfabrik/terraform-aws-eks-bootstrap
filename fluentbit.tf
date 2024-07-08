locals {
  fluentbit_namespace = "amazon-cloudwatch"
}

module "fluentbit" {
  count = var.enable_fluentbit ? 1 : 0

  source                   = "github.com/sparkfabrik/terraform-helm-fluentbit?ref=0.3.1"
  namespace                = local.fluentbit_namespace
  aws_region               = data.aws_region.current.name
  cluster_oidc_issuer_host = module.eks.oidc_provider
  cluster_name             = module.eks.cluster_name

  additional_exclude_from_application_log_group = concat(
    var.enable_cert_manager ? [
      "certificate-manager-cert-manager-cainjector",
      "certificate-manager-cert-manager-webhook",
      "certificate-manager-cert-manager",
    ] : [],
    var.enable_ingress_nginx ? [
      "ingress-nginx-controller",
      "ingress-nginx-defaultbackend",
    ] : [],
    var.enable_kube_prometheus_stack ?
    [
      "kube-prometheus-stack-grafana",
      "kube-prometheus-stack-kube-state-metrics",
      "kube-prometheus-stack-operator",
      "kube-prometheus-stack-prometheus-node-exporter",
      "prometheus-kube-prometheus-stack-prometheus",
    ] : [],
    var.fluentbit_additional_exclude_from_application_log_group
  )

  additional_include_in_platform_log_group = concat(
    var.enable_cert_manager ? [
      "certificate-manager-cert-manager-cainjector",
      "certificate-manager-cert-manager-webhook",
      "certificate-manager-cert-manager",      
    ] : [],
    var.enable_ingress_nginx ? [
      "ingress-nginx-controller",
      "ingress-nginx-defaultbackend",
    ] : [],
    var.fluentbit_additial_include_in_platform_log_group
  )

  additional_filters = templatefile(
    "${path.module}/files/fluentbit/additional-filters.conf.tftpl",
    {
      exclude_http_user_agents = ["kube-probe", "ELB-HealthChecker", "GoogleStackdriverMonitoring-UptimeChecks"]
    }
  )

  # @TODO: the web server must be enabled to have liveness probe working
  #        here the issue about that problem:
  #        https://github.com/aws/eks-charts/issues/983#issuecomment-1700374700
  fluentbit_http_server_enabled = true
}
