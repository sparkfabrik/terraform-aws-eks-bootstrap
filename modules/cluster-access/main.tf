locals {
  customer_application_namespaces = distinct(flatten([
    for k, app in var.customer_application : [
      for namespace in app.namespaces : {
        app_name = k
        namespace_name = namespace
      }
  ]]))
}


resource "kubectl_manifest" "role_developer" {
  for_each = { for entry in local.customer_application_namespaces : "${entry.app_name}-${entry.namespace_name}" => entry } 
  
  yaml_body = templatefile(
    "${path.module}/files/developer_role.yaml",
    {
      namespace = each.key
    }
  )
}

resource "kubectl_manifest" "rolebinding_developer" {
  for_each = { for entry in local.customer_application_namespaces : "${entry.app_name}-${entry.namespace_name}" => entry } 

  yaml_body = templatefile(
    "${path.module}/files/developer_role_binding.yaml",
    {
      namespace  = each.key
      group_name = var.developer_group_name
    }
  )
}

resource "kubectl_manifest" "role_admin" {
  for_each = { for entry in local.customer_application_namespaces : "${entry.app_name}-${entry.namespace_name}" => entry }

  yaml_body = templatefile(
    "${path.module}/files/admin_role.yaml",
    {
      namespace = each.key
    }
  )
}

resource "kubectl_manifest" "rolebinding_admin" {
  for_each = { for entry in local.customer_application_namespaces : "${entry.app_name}-${entry.namespace_name}" => entry }

  yaml_body = templatefile(
    "${path.module}/files/admin_role_binding.yaml",
    {
      namespace  = each.key
      group_name = var.admin_group_name
    }
  )
}
