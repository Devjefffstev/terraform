output "aws_eks" {
  value = module.aws_eks.cluster_eks.eks_properties
}
output "helm_charts" {
  value     = module.helm_charts
  sensitive = true

}
output "opencost_user_key" {
  value     = aws_iam_access_key.opencost_user_key
  sensitive = true

}
output "aws_s3_bucket" {
  value     = aws_s3_bucket.main
  sensitive = true

}
output "account_properties" {
  value = data.aws_account_primary_contact.test
  
}
output "unique_value" {
  value = "${substr(data.aws_caller_identity.current.account_id, 8, 12)}-${data.aws_region.current.region}"
}
