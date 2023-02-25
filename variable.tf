

#########################################################
# VARIABLE BLOCK
#########################################################

variable "enable_dns_hostnames" {
    type = bool
    description = "enable dns hostnames"
    default = true  
}

variable "vpc_cidr" {
    type = string
    description = "passing vpc cidr"  
}

variable "enable_dns_support" {
    type = bool
    description = "enable dns support"
    default = true  
}

variable "public_subnet_cidr" {
    type = list
    description = "public subnet cidr"
    default = []  
}

variable "backend_subnet_cidr" {
    type = list
    description = "backend subnet cidr"
    default = []  
}

variable "database_subnet_cidr" {
    type = list
    description = "database subnet cidr"
    default = []  
}

variable "availability_zones" {
    type = list
    description = "calling availability zone from data source"
    default = []
  
}

variable "component" {
    type = string
    description = "passing component name"     
}