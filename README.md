# vpc-module
Creating a VPC Module

Usage
'''
module "vpc" {
    source = git::https://github.com/lekankeshaws/vpc-module.git

    component = []
    availability_zones = []
    public_subnet_cidr = []
    backend_subnet_cidr = []
    database_subnet_cidr = []
      
}

'''
