resource "aws_eks_cluster" "main" {
  name                          = var.eks_cluster_name
  bootstrap_self_managed_addons = var.bootstrapSelfManagedAddons
  access_config {
    authentication_mode                         = var.access_config.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.access_config.bootstrap_cluster_creator_admin_permissions
  }

  role_arn = var.role_arn
  version  = var.version_eks

  vpc_config {
    subnet_ids              = var.vpc_config.subnet_ids
    endpoint_public_access  = var.vpc_config.endpoint_public_access
    endpoint_private_access = var.vpc_config.endpoint_private_access
    public_access_cidrs     = var.vpc_config.public_access_cidrs
  }
  compute_config {
    enabled       = try(var.compute_config.enable, true)
    node_pools    = var.compute_config.node_pools
    node_role_arn = var.compute_config.node_role_arn
  }
  kubernetes_network_config {
    elastic_load_balancing {
      enabled = try(var.kubernetes_network_config.elastic_load_balancing.enabled, true)
    }
  }
  storage_config {
    block_storage {
      enabled = var.storage_config.block_storage.enabled
    }
  }
}
# resource "aws_eks_node_group" "example" {
#   cluster_name    = var.eks_cluster_name
#   node_group_name = "node_group_default_${var.eks_cluster_name}"
#   node_role_arn   = var.aws_eks_node_group.node_role_arn
#   subnet_ids      = var.vpc_config.subnet_ids

#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   depends_on = [aws_eks_cluster.main]
# }

resource "aws_eks_addon" "main" {
  for_each = local.eks_addons
  cluster_name = aws_eks_cluster.main.id
  addon_name   = each.value.addon_name
}
