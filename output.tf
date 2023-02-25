

output "igw_id" {
    value = try(aws_internet_gateway.igw.id, "")
}

output "vpc_id" {
    value = try(aws_vpc.main.id, "")
}

output "nat_gw_id" {
    value = try(aws_nat_gateway.ngw[0].id, "")
}

