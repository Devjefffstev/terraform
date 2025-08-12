resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags       = var.tags  
  
}

resource "aws_subnet" "main" {
  for_each   = local.subnets
  vpc_id     = each.value.vpc_id
  cidr_block = each.value.cidr_block 
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = each.value.tags

}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.tags.Name}-igw" })
}
resource "aws_route_table" "main" {  
  for_each = local.subnets
  vpc_id = each.value.vpc_id
  tags   = merge(var.tags, { Name = "${var.tags.Name}-rtb" })

  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = try(aws_internet_gateway.main.id,null)
      nat_gateway_id = try(route.value.nat_gateway_id, null)
    }
    
  }
  
}
resource "aws_route_table_association" "main" {
  for_each = local.subnets
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[each.key].id
}