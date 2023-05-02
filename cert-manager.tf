## https://artifacthub.io/packages/helm/cert-manager/cert-manager
locals {
  default_cert_manager_helm_config = {
    name              = "certificate-manager"
    repository        = "https://charts.jetstack.io"
    helm_release_name = "cert-manager"
    chart_version     = "v1.11.1"
    namespace         = "cert-manager"
    create_namespace  = true
  }

  cert_manager_helm_config = merge(
    local.default_cert_manager_helm_config,
    var.cert_manager_helm_config
  )

  cert_manager_cluster_issuer_name         = "letsencrypt-${var.cluster_name}"
  cert_manager_staging_cluster_issuer_name = "letsencrypt-${var.cluster_name}-staging"

  cluster_issuer_manifests = split(
    "\n---\n",
    templatefile(
      "${path.module}/files/cert-manager/cluster-issuer.yaml",
      {
        cluster_issuer_name         = local.cert_manager_cluster_issuer_name
        secret_name                 = local.cert_manager_cluster_issuer_name
        staging_cluster_issuer_name = local.cert_manager_staging_cluster_issuer_name
        staging_secret_name         = local.cert_manager_staging_cluster_issuer_name
        email                       = var.letsencrypt_email
      }
    )
  )
  cluster_issuer_manifests_count = length(local.cluster_issuer_manifests)  
}

resource "kubernetes_namespace" "cert_manager" {
  count = try(local.cert_manager_helm_config["create_namespace"], true) && local.cert_manager_helm_config["namespace"] != "kube-system" && var.enable_cert_manager ? 1 : 0

  metadata {
    name = local.cert_manager_helm_config["namespace"]
  }
}

resource "helm_release" "cert_manager" {
  count = var.enable_cert_manager ? 1 : 0

  name       = local.cert_manager_helm_config.name
  repository = local.cert_manager_helm_config.repository
  chart      = local.cert_manager_helm_config.helm_release_name
  namespace  = local.cert_manager_helm_config.namespace
  version    = local.cert_manager_helm_config.chart_version

  values = [templatefile(
    "${path.module}/files/cert-manager/values.yaml",
    {
      cluster_issuer_name   = "letsencrypt-${var.cluster_name}"
    }
  )]

  depends_on = [
    module.eks, kubernetes_namespace.cert_manager
  ]
}

resource "kubectl_manifest" "cert_manager_cluster_issuer" {
  count      = var.install_letsencrypt_issuers ? local.cluster_issuer_manifests_count : 0

  yaml_body  = local.cluster_issuer_manifests[count.index]
  depends_on = [helm_release.cert_manager]
}
