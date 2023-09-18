
module "primary_sbtphapp_vpc" {
    source = "./vpc"
    region = "us-east-1"
    vpc_name = "primary_sbtphapp_vpc"
}

module "secondary_sbtphapp_vpc" {
    providers  = {
        aws = aws.secondary
    }
    source = "./vpc"
    region = "us-east-2"
    vpc_name = "secondary_sbtphapp_vpc"
}


output "vpc_id" {
   value = module.primary_sbtphapp_vpc.vpc_id
}

output "frontend_subnet_id" {
    value = module.primary_sbtphapp_vpc.frontend_subnet_id
}

output "backend_subnet_id" {
    value = module.primary_sbtphapp_vpc.backend_subnet_id
}

output "database_subnet_id" {
    value = module.primary_sbtphapp_vpc.database_subnet_id
}

output "database_sg_id" {
    value = module.primary_sbtphapp_vpc.database_sg_id
}

output "frontend_sg_id" {
    value = module.primary_sbtphapp_vpc.frontend_sg_id
}

output "backend_sg_id" {
    value = module.primary_sbtphapp_vpc.backend_sg_id
}


output "sbtphapp_public_rt_id" {
    value = module.primary_sbtphapp_vpc.sbtphapp_public_rt_id
}