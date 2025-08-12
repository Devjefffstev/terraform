locals {
  subnets = {
    for subnet in var.subnets : "subnet-${index(var.subnets, subnet)}" => merge(subnet, {
      vpc_id = aws_vpc.main.id
    })
  }
}
