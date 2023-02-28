

output "vpc_id_arg" {
  value = module.vpc.vpc_id
}

output "igw_id_arg" {
  value = module.vpc.igw_id
}

output "nat_id" {
  value = module.vpc.nat_gw_id
}