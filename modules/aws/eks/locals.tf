locals {
  eks_addons = {
  for addon_prop in var.eks_addons : "${var.eks_cluster_name}-addon-${addon_prop.addon_name}" => addon_prop
  }  
}