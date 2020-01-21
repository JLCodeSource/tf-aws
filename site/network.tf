# Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file
# except in compliance with the License. A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under the License.

#
# VPC
#
resource "aws_vpc" "trt" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
      Name = "trt_vpc"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#
#  IGW
#
resource "aws_internet_gateway" "trt" {
  vpc_id = aws_vpc.trt.id
  tags = {
      Name = "trt_igw"
  }
}

#
# Public Subnets
#
resource "aws_subnet" "trt_pub" {
  vpc_id = aws_vpc.trt.id
  count = length(var.subnets)

  cidr_block = cidrsubnet(var.vpc_cidr, var.newbits, count.index)
  availability_zone = var.subnets[count.index]
  tags = {
    Name = "trt_public_subnet_${var.subnets[count.index]}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
 
  }
}

#
# EIP
#
resource "aws_eip" "trt" {
  count = length(var.subnets)

  tags = {
    Name = "trt_eip_${var.subnets[count.index]}"
  }
}

#
# NAT Gateways
#
resource "aws_nat_gateway" "trt" {
  count = length(var.subnets)

  allocation_id = element(aws_eip.trt.*.id, count.index)
  subnet_id = element(aws_subnet.trt_pub.*.id, count.index)
  tags = {
    Name = "trt_gw_${var.subnets[count.index]}"
  }
  depends_on = [aws_internet_gateway.trt]
}

#
# Private Subnets
#
resource "aws_subnet" "trt_prv" {
  vpc_id = aws_vpc.trt.id
  count = length(var.subnets)

  cidr_block = cidrsubnet(var.vpc_cidr, var.newbits, count.index+4)
  availability_zone = var.subnets[count.index]
  tags = {
    Name = "trt_private_subnet_${var.subnets[count.index]}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

#
# Public Routing Tables
#
resource "aws_route_table" "trt_pub" {
  vpc_id = aws_vpc.trt.id

  count = length(var.subnets)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.trt.id
  }
  tags = {
    Name = "trt_public_route_table_${var.subnets[count.index]}"
  }
}

#
# Private Routing Tables
#
resource "aws_route_table" "trt_prv" {
  vpc_id = aws_vpc.trt.id

  count = length(var.subnets)
  tags = {
    Name = "trt_private_route_table_${var.subnets[count.index]}"
  }
}

#
# Private Route
#
resource "aws_route" "trt_prv" {
  count = length(var.subnets)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id = element(aws_route_table.trt_prv.*.id, count.index)
  nat_gateway_id = element(aws_nat_gateway.trt.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

#
# Public Route Association
#
resource "aws_route_table_association" "trt_pub" {
  count = length(var.subnets)

  subnet_id = element(aws_subnet.trt_pub.*.id, count.index)
  route_table_id = element(aws_route_table.trt_pub.*.id, count.index)
}

#
# Private Route Assocation
#
resource "aws_route_table_association" "trt_prv" {
  count = length(var.subnets)

  subnet_id = element(aws_subnet.trt_prv.*.id, count.index)
  route_table_id = element(aws_route_table.trt_prv.*.id, count.index)
}