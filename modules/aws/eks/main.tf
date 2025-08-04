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
  dynamic "compute_config" {
    for_each = var.compute_config != null ? [var.compute_config] : []
    content {
      enabled       = try(var.compute_config.enable, null)
      node_pools    = try(var.compute_config.node_pools, null)
      node_role_arn = try(var.compute_config.node_role_arn, null)
    }
  }
  dynamic "kubernetes_network_config" {
    for_each = var.kubernetes_network_config != null ? [var.kubernetes_network_config] : []
    content {
      dynamic "elastic_load_balancing" {
        for_each = var.kubernetes_network_config.elastic_load_balancing != null ? [var.kubernetes_network_config.elastic_load_balancing] : []
        content {
          enabled = try(elastic_load_balancing.value.enabled, null)
        }
      }
    }
  }


  # storage_config {
  #   block_storage {
  #     enabled = try(var.storage_config.block_storage.enabled, null)
  #   }
  # }
}

resource "aws_eks_node_group" "main" {
  for_each        = var.eks_node_group != null ? var.eks_node_group : {}
  cluster_name    = var.eks_cluster_name
  node_group_name = each.key
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = each.value.subnet_ids
  instance_types  = each.value.instance_types
  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  update_config {
    max_unavailable = each.value.update_config.max_unavailable
  }

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_addon" "pre" {
  for_each                    = local.eks_addons_pre
  cluster_name                = aws_eks_cluster.main.id
  addon_name                  = each.value.addon_name
  addon_version               = try(each.value.addon_version, null)
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, null)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts_on_create, null)
  dynamic "pod_identity_association" {
    for_each = each.value.pod_identity_association != null ? [each.value.pod_identity_association] : []
    content {
      role_arn        = pod_identity_association.value.role_arn
      service_account = pod_identity_association.value.service_account
    }
  }
  depends_on = [aws_eks_cluster.main]
}
resource "aws_eks_addon" "post" {
  for_each                    = local.eks_addons_post
  cluster_name                = aws_eks_cluster.main.id
  addon_name                  = each.value.addon_name
  addon_version               = try(each.value.addon_version, null)
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, null)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts_on_create, null)
  dynamic "pod_identity_association" {
    for_each = each.value.pod_identity_association != null ? [each.value.pod_identity_association] : []
    content {
      role_arn        = pod_identity_association.value.role_arn
      service_account = pod_identity_association.value.service_account
    }
  }
  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, aws_eks_addon.pre]
}
