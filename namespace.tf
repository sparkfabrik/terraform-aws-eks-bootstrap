## Application Namespaces
resource "kubernetes_namespace" "application_namespace" {
  for_each = var.cluster_application

  metadata {
    labels = {
      name = each.value.namespace
    }

    name = each.value.namespace
  }
  depends_on = [module.eks]
}