module "aws_iam" {
  source = "../../../modules/aws/iam"
  aws_iam_role = local.this_aws_iam_role
}

module "aws_vpc" {
  source     = "../../../modules/aws/vpc"
  cidr_block = var.vpc_cidr_block
  tags = var.tags
  subnets = var.subnets
}

module "eks_example" {
  source           = "../../../modules/aws/eks"
  eks_cluster_name = "eks-cluster-opencost-cost"
  access_config = {
    authentication_mode = "API"
    # bootstrap_cluster_creator_admin_permissions = false
  }
  role_arn = module.aws_iam.aws_iam_role_properties.eks_cluster_example.arn
  vpc_config = {
    subnet_ids              = local.subnets_created_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"] # Allow public access from anywhere, adjust as needed
  }
  kubernetes_network_config = {
    elastic_load_balancing = {
      enabled = true
    }
  }
  compute_config = {
    node_pools = [
      "general-purpose", "system"
    ]
    node_role_arn = module.aws_iam.aws_iam_role_properties.eks_auto_node_example.arn
  }
  storage_config = {
    block_storage = {
      enabled = true
    }
  }
  aws_eks_node_group = {
    node_role_arn = module.aws_iam.aws_iam_role_properties.eks_auto_node_example.arn
  }
  depends_on = [module.aws_iam]
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
