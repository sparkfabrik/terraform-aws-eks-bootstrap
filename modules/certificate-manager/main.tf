locals {
  cluster_issuer_manifests = var.install_cluster_issuer ? split(
    "\n---\n",
    templatefile(
      "${path.module}/files/cluster-issuer.yaml",
      {
        cluster_issuer_name         = var.cluster_issuer_name
        secret_name                 = var.secret_name
        staging_cluster_issuer_name = var.staging_cluster_issuer_name
        staging_secret_name         = var.staging_secret_name
        email                       = var.email
      }
    )
  ) : []
  cluster_issuer_manifests_count = length(local.cluster_issuer_manifests)
}

resource "kubectl_manifest" "cert_manager_cluster_issuer" {
  count      = local.cluster_issuer_manifests_count
  yaml_body  = local.cluster_issuer_manifests[count.index]
  depends_on = [helm_release.cert_manager_release]
}

resource "helm_release" "cert_manager_release" {
  name       = var.helm_release_name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = var.namespace
  version    = var.chart_version

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "ingressShim.defaultIssuerName"
    value = var.cluster_issuer_name
  }

  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }

  set {
    name  = "resources.requests.cpu"
    value = "2m"
  }

  set {
    name  = "resources.requests.memory"
    value = "200Mi"
  }

  set {
    name  = "webhook.resources.requests.cpu"
    value = "1m"
  }

  set {
    name  = "webhook.resources.requests.memory"
    value = "16Mi"
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
    kubernetes_namespace.namespace,
  ]
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {}
    labels      = {}
    name        = var.namespace
  }
}
