resource "kubernetes_namespace" "customer_application" {
  for_each = toset(local.eks_application_namespaces)

  metadata {
    labels = {
      name = each.value
    }

    name = each.value
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
