module "aws_iam" {
  source       = "../../../modules/aws/iam"
  aws_iam_role = local.this_aws_iam_role
}

module "aws_vpc" {
  source     = "../../../modules/aws/vpc"
  cidr_block = var.vpc_cidr_block
  tags       = var.tags
  subnets    = var.subnets
}

module "eks_example" {
  source           = "../../../modules/aws/eks"
  eks_cluster_name = "eks-cluster-opencost-cost"
  access_config    = var.access_config
  role_arn         = module.aws_iam.aws_iam_role_properties.eks_cluster_role.arn
  vpc_config = merge(var.vpc_config, {
    subnet_ids = local.subnets_created_ids
  })
  # kubernetes_network_config = {
  #   elastic_load_balancing = {
  #     enabled = true
  # } }
  # compute_config = {
  #   node_pools = [
  #     "general-purpose", "system"
  #   ]
  #   node_role_arn = module.aws_iam.aws_iam_role_properties.eks_auto_mode_node_pool.arn
  #   enable = true
  # }
  # storage_config = {
  #   block_storage = {
  #     enabled = true
  #   }
  # }
  eks_addons = [{
    addon_name = "vpc-cni"

    }, {
    addon_name                  = "coredns"
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"

    }, {
    addon_name = "kube-proxy"

    },
    {
      addon_name = "eks-pod-identity-agent"
    }
    , {
      addon_name = "aws-ebs-csi-driver"
      pod_identity_association = {
        role_arn        = module.aws_iam.aws_iam_role_properties.eks_auto_mode_csi_driver.arn
        service_account = "ebs-csi-controller-sa"
      }
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"

    }
  ]
  eks_node_group = local.eks_node_group

  depends_on = [module.aws_iam, module.aws_vpc]
}

locals {
  eks_node_group = {
    for node_group_name, node_group_details in var.eks_node_group : node_group_name => merge(node_group_details, {
      subnet_ids    = local.subnets_created_ids
      node_role_arn = module.aws_iam.aws_iam_role_properties.eks_auto_mode_group_nodes.arn
      scaling_config = merge(node_group_details.scaling_config, {
        desired_size = try(node_group_details.scaling_config.desired_size, 1)
        max_size     = try(node_group_details.scaling_config.max_size, 3)
        min_size     = try(node_group_details.scaling_config.min_size, 1)
      })
    })
  }
}
## In order to connect to the EKS cluster and see the objects, you need to create a eks_access_entry for your user.
resource "aws_eks_access_entry" "example" {
  cluster_name  = module.eks_example.eks_properties.name
  principal_arn = "arn:aws:iam::768312754627:user/jeffsoto"
  type          = "STANDARD"

}
resource "aws_eks_access_policy_association" "example" {
  for_each = {
    "policy1" = {
      cluster_name  = module.eks_example.eks_properties.name
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
      principal_arn = aws_eks_access_entry.example.principal_arn
    }
    "policy2" = {
      cluster_name  = module.eks_example.eks_properties.name
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
      principal_arn = aws_eks_access_entry.example.principal_arn
    }
    "policy3" = {
      cluster_name  = module.eks_example.eks_properties.name
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = aws_eks_access_entry.example.principal_arn
    }
    "policy4" = {
      cluster_name  = module.eks_example.eks_properties.name
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSNetworkingClusterPolicy"
      principal_arn = aws_eks_access_entry.example.principal_arn
    }
  }
  cluster_name  = each.value.cluster_name
  policy_arn    = each.value.policy_arn
  principal_arn = each.value.principal_arn
  access_scope {
    type = "cluster"
  }
}

# to run this module using a inline command terraform apply --auto-approve 
# give me a command to run terraform apply with auto-approve multiple times
# bash - c 'for i in {1..5}; do terraform apply --auto-approve; done'
