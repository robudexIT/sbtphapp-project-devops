
module "sbtphapp_iam" {
    source = "./iam"

}
module "primary_sbtphapp_vpc" {
    source = "./vpc"
    region = "us-east-1"
    vpc_name = "primary_sbtphapp_vpc"
}

module "primary_make_db_public_lambda" {
    source = "./lambda"
    sbtphapp_lambda_role_arn = module.sbtphapp_iam.sbtphapp_lambda_role_arn
    vpc_id = module.primary_sbtphapp_vpc.vpc_id
    database_subnet_id = module.primary_sbtphapp_vpc.database_subnet_id
    sbtphapp_public_rt_id =  module.primary_sbtphapp_vpc.sbtphapp_public_rt_id
}

module "sbtphapp_db_instance" {
   source  = "./ec2"
   mysql_app_user = "sbtphapp_admin"
   mysql_app_pwd =  "sbtph@2023"
   mysql_rep_user = "replication_user"
   mysql_rep_pwd  = "sbtph@2023"
   region =  "us-east-1"
   instance_name = "Database"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.primary_sbtphapp_vpc.database_subnet_id
   instance_sg_id = module.primary_sbtphapp_vpc.database_sg_id
   instance_bootup_script = "db_instance_bootup_script.yaml"

}

module "sbtphapp_backend_instance" {
   source  = "./ec2"
   mysql_app_user = "sbtphapp_admin"
   mysql_app_pwd =  "sbtph@2023"
   mysql_rep_user = "replication_user"
   mysql_rep_pwd  = "sbtph@2023"
   region =  "us-east-1"
   instance_name = "Backend"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.primary_sbtphapp_vpc.backend_subnet_id
   instance_sg_id = module.primary_sbtphapp_vpc.backend_sg_id
   instance_bootup_script = "backend_instance_bootup_script.yaml"

}

module "sbtphapp_frontend_instance" {
   source  = "./ec2"
   mysql_app_user = "sbtphapp_admin"
   mysql_app_pwd =  "sbtph@2023"
   mysql_rep_user = "replication_user"
   mysql_rep_pwd  = "sbtph@2023"
   region =  "us-east-1"
   instance_name = "sbtphapp_frontend_instance"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.primary_sbtphapp_vpc.frontend_subnet_id
   instance_sg_id = module.primary_sbtphapp_vpc.frontend_sg_id
   instance_bootup_script = "frontend_instance_bootup_script.yaml"

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

output "made_db_public_invoke_result" {
    value =  module.primary_make_db_public_lambda.made_db_public_invoke_result
}