locals {
  eks_addons = {
  for addon_prop in var.eks_addons : "${aws_eks_cluster.main.id}-addon-${addon_prop.addon_name}" => addon_prop
  }  
}