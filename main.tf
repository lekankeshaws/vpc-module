

#########################################################
# ROOT MODULE
#########################################################

#########################################################
# LOCAL BLOCK
#########################################################

locals {
  vpc_id = aws_vpc.main.id  
}

#########################################################
# VPC RESOURCE
#########################################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

}

#########################################################
# INTERNET GATEWAY RESOURCE
#########################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id

  tags = {
    Name = "${var.component}_igw"
  }
}

#########################################################
# PUBLIC SUBNET RESOURCE
#########################################################
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr)

  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.component}_public_subnet_${count.index + 1}"
  }
}

#########################################################
# BACKEND SUBNET RESOURCE
#########################################################
resource "aws_subnet" "backend_subnet" {
  count = length(var.backend_subnet_cidr)

  vpc_id            = local.vpc_id
  cidr_block        = var.backend_subnet_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index) # element(local.azs, count.index) this is, incase you have more than 2 cidr

  tags = {
    Name = "${var.component}_backend_subnet_${count.index + 1}"
  }
}

#########################################################
# DATABASE SUBNET RESOURCE
#########################################################
resource "aws_subnet" "database_subnet" {
  count = length(var.database_subnet_cidr)

  vpc_id            = local.vpc_id
  cidr_block        = var.database_subnet_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.component}_database_subnet_${count.index + 1}"
  }
}

#########################################################
# PUBLIC ROUTE TABLE
#########################################################
resource "aws_route_table" "public_route_table" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.component}_public_route_table"
  }
}

#########################################################
# DEFAULT ROUTE TABLE
#########################################################
resource "aws_default_route_table" "private_default_rt_table" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = try(aws_nat_gateway.ngw[0].id, "")
  }

  tags = {
    Name = "sbx_default_rt_table"
  }
}

#########################################################
# PUBLIC ROUTE TABLE ASSOCIATION 
#########################################################

resource "aws_route_table_association" "public_rt_table" {
  count = length(aws_subnet.public_subnet)

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

#########################################################
# NAT GATEWAY
#########################################################

resource "aws_nat_gateway" "ngw" {
  count = length(var.public_subnet_cidr) > 0 ? 1 : 0
  depends_on = [aws_internet_gateway.igw]

  allocation_id = try(aws_eip.eip[0].id, "")
  subnet_id     = try(aws_subnet.public_subnet[0].id, "")

  tags = {
    Name = "sbx_nat_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.

}

#########################################################
# ELASTIC IP
#########################################################

resource "aws_eip" "eip" {
  count = length(var.public_subnet_cidr) > 0 ? 1 : 0
  depends_on = [aws_internet_gateway.igw]

  vpc = true
}