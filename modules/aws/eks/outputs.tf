output "eks_properties" {
  description = "Properties of the EKS cluster"
  value       = aws_eks_cluster.main
  
}