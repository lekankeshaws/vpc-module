# vpc-module
Creating a VPC Module

Usage

```
module "vpc" {
    source = git::https://github.com/lekankeshaws/vpc-module.git

    component = "test_module"
    vpc_cidr = "10.0.0.0/16"
    availability_zones = ["us-east-1a", "us-east-1b"]
    public_subnet_cidr = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
    backend_subnet_cidr = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
    database_subnet_cidr = ["10.0.51.0/24", "10.0.53.0/24", "10.0.55.0/24"]
      
}

```
