resource "kubectl_manifest" "role_developer" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/developer_role.yaml",
    {
      namespace = each.value
    }
  )
}

resource "kubectl_manifest" "rolebinding_developer" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/developer_role_binding.yaml",
    {
      namespace  = each.value
      group_name = var.developer_group_name
    }
  )
}

resource "kubectl_manifest" "role_admin" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/admin_role.yaml",
    {
      namespace = each.value
    }
  )
}

resource "kubectl_manifest" "rolebinding_admin" {
  for_each = toset(var.namespaces)

  yaml_body = templatefile(
    "${path.module}/admin_role_binding.yaml",
    {
      namespace  = each.value
      group_name = var.admin_group_name
    }
  )
}
