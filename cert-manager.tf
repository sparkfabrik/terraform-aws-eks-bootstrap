## https://artifacthub.io/packages/helm/cert-manager/cert-manager
locals {
  cert_manager_namespace                   = "cert-manager"
  cert_manager_chart_version               = "v1.11.1"
  cert_manager_cluster_issuer_name         = "letsencrypt-${var.project}"
  cert_manager_staging_cluster_issuer_name = "letsencrypt-${var.project}-staging"
  cert_manager_contact_email               = "example@example.com"
}

resource "helm_release" "cert_manager" {
  name             = "certificate-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = local.cert_manager_namespace
  version          = local.cert_manager_chart_version
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "ingressShim.defaultIssuerName"
    value = local.cert_manager_cluster_issuer_name
  }

  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }

  set {
    name  = "cainjector.resources.requests.cpu"
    value = "5m"
  }

  set {
    name  = "cainjector.resources.requests.memory"
    value = "160Mi"
  }

  depends_on = [
    module.eks, kubernetes_namespace.application_namespace
  ]
}

locals {
  cluster_issuer_manifests = split(
    "\n---\n",
    templatefile(
      "${path.module}/files/cert-manager/cluster-issuer.yaml",
      {
        cluster_issuer_name         = local.cert_manager_cluster_issuer_name
        secret_name                 = local.cert_manager_cluster_issuer_name
        staging_cluster_issuer_name = local.cert_manager_staging_cluster_issuer_name
        staging_secret_name         = local.cert_manager_staging_cluster_issuer_name
        email                       = local.cert_manager_contact_email
      }
    )
  )
  cluster_issuer_manifests_count = length(local.cluster_issuer_manifests)
}

resource "kubectl_manifest" "cert_manager_cluster_issuer" {
  count      = local.cluster_issuer_manifests_count

  yaml_body  = local.cluster_issuer_manifests[count.index]
  depends_on = [helm_release.cert_manager]
}
