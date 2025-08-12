locals {
  eks_addons_pre = {
  for addon_prop in var.eks_addons : "${var.eks_cluster_name}-addon-${addon_prop.addon_name}" => addon_prop
    if !contains( ["coredns",  "aws-ebs-csi-driver"], addon_prop.addon_name) 
    
  }
  eks_addons_post = {
  for addon_prop in var.eks_addons : "${var.eks_cluster_name}-addon-${addon_prop.addon_name}" => addon_prop
    if contains( ["coredns",  "aws-ebs-csi-driver"], addon_prop.addon_name) 
  }
}