# Creaate customer application namespace
## By convention, each namespace is suffixed with the customer application key.

locals {
  customer_application_namespaces = distinct(flatten([
    for k, app in var.customer_application : [
      for namespace in app.namespaces : {
        app_name = k
        namespace_name = namespace
      }
  ]]))
}

resource "kubernetes_namespace" "customer_application" {
  for_each = { for entry in local.customer_application_namespaces : "${entry.app_name}-${entry.namespace_name}" => entry }

  metadata {
    labels = {
      name = each.key
    }

    name = each.key
  }

  # Ignore the Firestarter package labels
  lifecycle {
    ignore_changes = [
      metadata[0].labels["git_commit_id"],
      metadata[0].labels["gitlab_environment"],
      metadata[0].labels["gitlab_pipeline_id"],
      metadata[0].labels["gitlab_project_id"],
      metadata[0].labels["gitlab_project_name"],
      metadata[0].labels["gitlab_release"],
      metadata[0].labels["pkg_project"],
      metadata[0].labels["pkg_vendor"],
    ]
  }

  depends_on = [module.eks]
}
