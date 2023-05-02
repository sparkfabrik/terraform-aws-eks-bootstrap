locals {
  # Node group default settings
  eks_managed_node_group_defaults = {
    subnets   = var.private_subnet_ids
    disk_size = 50
    capacity_type  = "ON_DEMAND"
  }

  admin_user_map_users = [
    for admin_user in var.admin_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${admin_user}"
      username = admin_user
      groups   = ["system:masters"]
    }
  ]

  developer_user_map_users = [
    for developer_user in var.developer_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${developer_user}"
      username = developer_user
      groups   = ["${var.project}-developers"]
    }
  ]
}
