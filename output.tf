

output "igw_id" {
    value = try(aws_internet_gateway.igw.id, "")
}

output "vpc_id" {
    value = try(aws_vpc.main.id, "")
}

output "nat_gw_id" {
    value = try(aws_nat_gateway.ngw[0].id, "")
}

output "public_subnet_id" {
    value = try(aws_subnet.public_subnet[*].id, "")
}

output "backend_subnet_id" {
    value = try(aws_subnet.backend_subnet[*].id, "")
}

output "database_subnet_id" {
    value = try(aws_subnet.database_subnet[*].id, "")
}



