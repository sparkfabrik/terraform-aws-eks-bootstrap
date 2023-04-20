# resource "kubernetes_namespace" "namespace" {
#   for_each = toset(var.application_projects.namespace)

#   metadata {
#     name = "${var.application_projects.name}-${each.value}"

#     labels = {
#       name = "${var.application_projects.name}-${each.value}"
#     }    
#   }
# }
