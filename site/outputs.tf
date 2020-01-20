output "vpc_id" {
    value = aws_vpc.trt.id
}

output "igw_id" {
    value = aws_internet_gateway.trt.id
}

output "public_subnets" {
    value = aws_subnet.trt_pub.*.id
}

output "public_cidr_blocks" {
    value = aws_subnet.trt_pub.*.cidr_block
}

output "eips" {
    value = aws_eip.trt.*.id
}

output "nat_gws" {
    value = aws_nat_gateway.trt.*.id
}

output "private_subnets" {
    value = aws_subnet.trt_prv.*.id
}

output "private_cidr_blocks" {
    value = aws_subnet.trt_prv.*.cidr_block
}

output "public_route_tables" {
    value = aws_route_table.trt_pub.*.id
}

output "private_route_tables" {
    value = aws_route_table.trt_prv.*.id
}

output "private_routes" {
    value = aws_route.trt_prv.*.id
}

output "public_route_table_associations" {
    value = aws_route_table_association.trt_pub.*.id
}

output "private_route_table_associations" {
    value = aws_route_table_association.trt_prv.*.id
}

