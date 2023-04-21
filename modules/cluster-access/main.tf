resource "kubectl_manifest" "role_developer" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/files/developer_role.yaml",
    {
      namespace = each.value
    }
  )
}

resource "kubectl_manifest" "rolebinding_developer" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/files/developer_role_binding.yaml",
    {
      namespace  = each.value
      group_name = var.developer_group_name
    }
  )
}

resource "kubectl_manifest" "role_admin" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/files/admin_role.yaml",
    {
      namespace = each.value
    }
  )
}

resource "kubectl_manifest" "rolebinding_admin" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/files/admin_role_binding.yaml",
    {
      namespace  = each.value
      group_name = var.admin_group_name
    }
  )
}
