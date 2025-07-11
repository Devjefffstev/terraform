module "aws_iam" {
  source = "../../../modules/aws/iam"
  aws_iam_role = {
    eks_role_and_policy = {
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Principal = {
              Service = "eks.amazonaws.com"
            }
            Action = [
              "sts:AssumeRole"
            , "sts:TagSession"]
          }
        ]
      })
      aws_iam_role_policy_attachment = [
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy" # Allows EKS to communicate with other services
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy" # Allows EKS worker nodes to communicate with the cluster
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy" # Allows EKS to pull images from ECR
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy" # Allows EKS to communicate with other services
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy" # Allows EKS to communicate with other services
        }
      ]
    }
    eks_node_role_and_policy = {
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Principal = {
              Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"

          }
        ]
      })
      aws_iam_role_policy_attachment = [
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy" # Allows EKS to communicate with other services
      }]
    }
  }

}

module "aws_vpc" {
  source     = "../../../modules/aws/vpc"
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks-example-vpc-opencost"
  }
  subnets = [{
    cidr_block        = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "eks-example-subnet-1"
    }
    },
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1b"
      tags = {
        Name = "eks-example-subnet-2"
      }
    }
  ]
}
locals {
  subnets_created_ids = [for subnet in module.aws_vpc.subnet_properties : subnet.id]

}



module "eks_example" {
  source           = "../../../modules/aws/eks"
  eks_cluster_name = "eks-cluster-opencostc"
  access_config = {
    authentication_mode = "API"
    # bootstrap_cluster_creator_admin_permissions = false
  }
  role_arn = module.aws_iam.aws_iam_role_properties.eks_role_and_policy.arn
  vpc_config = {
  subnet_ids = local.subnets_created_ids }
  kubernetes_network_config = {
    elastic_load_balancing = {
      enabled = true
    }
  }
  compute_config = {
    node_pools = [
      "general-purpose",
    ]
    node_role_arn = module.aws_iam.aws_iam_role_properties.eks_node_role_and_policy.arn
  }
  storage_config = {
    block_storage = {
      enabled = true
    }
  }
  depends_on = [module.aws_iam]
}
