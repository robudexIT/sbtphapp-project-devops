
module "sbtphapp_iam" {
    source = "./iam"

}
module "primary_sbtphapp_vpc" {
    source = "./vpc"
    region = "us-east-1"
    vpc_name = "primary_sbtphapp_vpc"
}

# module "secondary_sbtphapp_vpc" {
#     providers  = {
#         aws = aws.secondary
#     }
#     source = "./vpc"
#     region = "us-east-2"
#     vpc_name = "secondary_sbtphapp_vpc"
# }



output "sbtphapp_lambda_role_arn" {
    value = module.sbtphapp_iam.sbtphapp_lambda_role_arn
}

output "sbtphapp_instance_profile_name" {
    value = module.sbtphapp_iam.sbtphapp_instance_profile_name
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