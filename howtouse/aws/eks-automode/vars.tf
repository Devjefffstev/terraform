# Define AWS access key and secret key variables
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string

}
variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

# Define AWS Roles for EKS cluster and nodes 
variable "this_aws_iam_role" {
  description = "IAM cluster/node role for EKS cluster. Send the path to the assume_role_policy file. Example: policies/cluster_role.json"
  type = map(object({
    assume_role_policy = string
    aws_iam_role_policy_attachment = list(object({
      policy_arn = string
    }))
  }))
  default = {
    eks_cluster_role = {
      assume_role_policy = "policies/cluster_role.json"
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
    eks_auto_mode_node_pool = {
      assume_role_policy = "policies/node_role.json"
      aws_iam_role_policy_attachment = [
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly" # Allows EKS to communicate with other services
        },
        # {
        #   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" # Allows EKS to manage networking for the worker nodes
        # }
      ]
    }
    eks_auto_mode_group_nodes = {
      assume_role_policy = "policies/node_role.json"
      aws_iam_role_policy_attachment = [
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" # Allows EKS to communicate with other services
        },
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" # Allows EKS to manage networking for the worker nodes
        }
      ]
    }
    eks_auto_mode_csi_driver = {
      assume_role_policy = "policies/pod.json"
      aws_iam_role_policy_attachment = [
        {
          policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        },      
      ]
    }
  }
}
# Define variable for VPC CIDR block
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "poc"
    Project     = "EKS-AutoMode"
    Name        = "eks-example-vpc-opencost"

  }
}
variable "subnets" {
  description = "List of subnets to create in the VPC"
  type = list(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    routes = list(object({
      cidr_block     = string
      gateway_id     = optional(string, null)
      nat_gateway_id = optional(string, null)
    }))
    tags                    = map(string)
  }))
  default = [
    {
      cidr_block              = "10.0.0.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      tags = {
        Name                              = "eks-example-subnet-1"
        "kubernetes.io/role/internal-elb" = "1"
      }
      routes = [
        {
          cidr_block = "0.0.0.0/0"
        }
      ]
    },
    {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = true
      tags = {
        Name                              = "eks-example-subnet-2"
        "kubernetes.io/role/internal-elb" = "1"
      }
      routes = [
        {
          cidr_block = "0.0.0.0/0"
        }
      ]
    },
    {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-east-1f"
      map_public_ip_on_launch = true
      tags = {
        Name                              = "eks-example-subnet-3"
        "kubernetes.io/role/internal-elb" = "1"
      }
      routes = [
        {
          cidr_block = "0.0.0.0/0"
        }
      ]
    }

  ]
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cluster-opencost-cost"
}
variable "access_config" {
  description = "Access configuration for the EKS cluster"
  type = object({
    authentication_mode                         = string
    bootstrap_cluster_creator_admin_permissions = optional(bool, false)
  })
  default = {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }
}
variable "vpc_config" {
  description = "VPC configuration for the EKS cluster"
  type = object({
    endpoint_public_access  = bool
    endpoint_private_access = bool
    public_access_cidrs     = optional(list(string), [])
  })
  default = {
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"] # Allow public access from anywhere, adjust as needed
  }
}
variable "eks_node_group" {
  type = map(object({

    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    update_config = object({
      max_unavailable = optional(number, 1)
    })
  }))
  default = {
    node_group_opencost = {
      scaling_config = {
        desired_size = 2
        max_size     = 3
        min_size     = 1
      }
      update_config = {
        max_unavailable = 1
      }
    }
  }
}
