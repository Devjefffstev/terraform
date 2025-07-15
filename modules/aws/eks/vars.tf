variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  validation {
    condition     = length(var.eks_cluster_name) < 100
    error_message = "EKS cluster name must not be empty and must only contain alphanumeric characters, underscores, or hyphens."
  }
}
variable "bootstrapSelfManagedAddons" {
  description = "Flag to bootstrap self-managed addons"
  type        = bool
  default     = false

}
variable "access_config" {
  description = "Access configuration for the EKS cluster"
  type = object({
    authentication_mode                         = string
    bootstrap_cluster_creator_admin_permissions = optional(bool, false)
  })
}
variable "role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}
variable "version_eks" {
  description = "EKS cluster version"
  type        = string
  default     = "1.33"
}
variable "vpc_config" {
  description = "VPC configuration for the EKS cluster"
  type = object({
    subnet_ids              = list(string)
    endpoint_public_access  = optional(bool, true)
    endpoint_private_access = optional(bool, true)
    public_access_cidrs     = optional(set(string), null)
  })
}
variable "compute_config" {
  description = "Access configuration for the EKS cluster"
  type = object({
    enable        = optional(bool, true)
    node_pools    = optional(list(string), null)
    node_role_arn = optional(string, null)
  })
}
variable "kubernetes_network_config" {
  description = "Kubernetes network configuration for the EKS cluster"
  type = object({
    elastic_load_balancing = object({
      enabled = optional(bool, true)
    })
  })

}
variable "storage_config" {
  description = "Storage configuration for the EKS cluster"
  type = object({
    block_storage = object({
      enabled = optional(bool, true)
    })
  })
}
variable "eks_addons" {
  description = "List of EKS addons to be installed"
  type = list(object({
    addon_name = string
    version    = optional(string, null)
  }))
  default = [{
    addon_name = "vpc-cni"
    }, {
    addon_name = "coredns"
    }, {
    addon_name = "kube-proxy"
    }, {
    addon_name = "eks-pod-identity-agent"
  }]
}
variable "eks_node_group" {
  type = map(object({
    node_role_arn = string
    subnet_ids    = list(string)
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    update_config = object({
      max_unavailable = optional(number, 1)
    })
  }))
  nullable = true
  default = null
}
