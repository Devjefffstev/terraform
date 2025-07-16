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

resource "aws_eks_node_group" "main" {
  for_each        = var.eks_node_group != null ? var.eks_node_group : {}
  cluster_name    = var.eks_cluster_name
  node_group_name = each.key
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = each.value.subnet_ids

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  update_config {
    max_unavailable = each.value.update_config.max_unavailable
  }

  depends_on = [aws_eks_addon.main]
}

resource "aws_eks_addon" "main" {
  for_each     = local.eks_addons
  cluster_name = aws_eks_cluster.main.id
  addon_name   = each.value.addon_name
  addon_version = try(each.value.addon_version, null)
}
