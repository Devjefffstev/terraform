output "module_aws_iam_role_properties" {
  description = "IAM role created for EKS cluster"
  value       = module.aws_iam  
}
output "module_aws_vpc_properties" {
  description = "VPC properties created for EKS cluster"
  value       = module.aws_vpc
  
}
output "local_subnets_created_ids" {
  description = "List of subnet IDs created by the VPC module"
  value       = local.subnets_created_ids
  
}
output "cluster_eks" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_example
}

# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane"
#   value       = module.eks.cluster_security_group_id
# }

# output "region" {
#   description = "AWS region"
#   value       = var.region
# }

# output "cluster_name" {
#   description = "Kubernetes Cluster Name"
#   value       = module.eks.cluster_name
# }