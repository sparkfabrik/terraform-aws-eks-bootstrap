## Customer application Namespace
resource "kubernetes_namespace" "customer_application" {
  for_each = var.customer_application

  metadata {
    labels = {
      name = each.value.namespace
    }

    name = each.value.namespace
  }

  depends_on = [module.eks]
}
