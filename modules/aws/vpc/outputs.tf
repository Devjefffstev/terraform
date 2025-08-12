output "vpc_properties" {
  description = "properties for VPC"
  value       = aws_vpc.main
  }
  output "subnet_properties" {
    description = "properties for subnets"
    value       = aws_subnet.main
  }