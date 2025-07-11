output "aws_iam_role_properties" {
  description = "IAM role properties"
  value       = aws_iam_role.main  
}
output "aws_iam_role_policy_attachment_properties" {
  description = "IAM role policy attachment properties"
  value       = aws_iam_role_policy_attachment.main
}