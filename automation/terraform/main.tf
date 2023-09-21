
module "sbtphapp_iam" {
    source = "./iam"

}
module "primary_sbtphapp_vpc" {
    source = "./vpc"
    region = "us-east-1"
    vpc_name = "primary_sbtphapp_vpc"
    depends_on = [ module.sbtphapp_iam ]

}


module "primary_sbtphapp_db_instance" {
   source  = "./ec2"

   mysql_app_user = var.mysql_app_user
   mysql_app_pwd =  var.mysql_app_pwd 
   mysql_rep_user = var.mysql_rep_user 
   mysql_rep_pwd  = var.mysql_rep_pwd 
  
   region =  "us-east-1"
   instance_name = "Database"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.primary_sbtphapp_vpc.database_subnet_id
   instance_sg_id = module.primary_sbtphapp_vpc.database_sg_id
   instance_bootup_script = "db_instance_bootup_script.yaml"

}

module "primary_sbtphapp_backend_instance" {
   source  = "./ec2"
   mysql_app_user = var.mysql_app_user
   mysql_app_pwd =  var.mysql_app_pwd 
   mysql_rep_user = var.mysql_rep_user 
   mysql_rep_pwd  = var.mysql_rep_pwd 
   region =  "us-east-1"
   instance_name = "Backend"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.primary_sbtphapp_vpc.backend_subnet_id
   instance_sg_id = module.primary_sbtphapp_vpc.backend_sg_id
   instance_bootup_script = "backend_instance_bootup_script.yaml"
   
   depends_on = [ module.primary_sbtphapp_db_instance ]

}

module "primary_sbtphapp_frontend_instance" {
   source  = "./ec2"
   mysql_app_user = var.mysql_app_user
   mysql_app_pwd =  var.mysql_app_pwd 
   mysql_rep_user = var.mysql_rep_user 
   mysql_rep_pwd  = var.mysql_rep_pwd 

   region =  "us-east-1"
   instance_name = "Frontend"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.primary_sbtphapp_vpc.frontend_subnet_id
   instance_sg_id = module.primary_sbtphapp_vpc.frontend_sg_id
   instance_bootup_script = "frontend_instance_bootup_script.yaml"

   depends_on = [ module.primary_sbtphapp_backend_instance ]

}

# module "primary_sbtphapp_make_db_private_lambda" {
#     source = "./lambda/makeprivate"
#     sbtphapp_lambda_role_arn = module.sbtphapp_iam.sbtphapp_lambda_role_arn
#     vpc_id = module.primary_sbtphapp_vpc.vpc_id
#     database_subnet_id = module.primary_sbtphapp_vpc.database_subnet_id

#     depends_on = [ module.primary_sbtphapp_frontend_instance ]
    
# }


# module "secondary_sbtphapp_vpc" {
#     providers  = {
#         aws = aws.secondary
#     }
#     source = "./vpc"
#     region = "us-east-2"
#     vpc_name = "secondary_sbtphapp_vpc"
#     depends_on = [ module.sbtphapp_iam]
# }

# module "secondary_make_db_public_lambda" {
#     source = "./lambda/makepublic"
#     providers  = {
#         aws = aws.secondary
#     }
#     sbtphapp_lambda_role_arn = module.sbtphapp_iam.sbtphapp_lambda_role_arn
#     vpc_id = module.primary_sbtphapp_vpc.vpc_id
#     database_subnet_id = module.secondary_sbtphapp_vpc.database_subnet_id
#     sbtphapp_public_rt_id =  module.secondary_sbtphapp_vpc.sbtphapp_public_rt_id

#      depends_on = [ module.secondary_sbtphapp_vpc ]
# }

# module "secondary_sbtphapp_db_instance" {
#    source  = "./ec2"
#    providers  = {
#         aws = aws.secondary
#     }
#    mysql_app_user = var.mysql_app_user
#    mysql_app_pwd =  var.mysql_app_pwd 
#    mysql_rep_user = var.mysql_rep_user 
#    mysql_rep_pwd  = var.mysql_rep_pwd 
  
#    region =  "us-east-2"
#    instance_name = "Database"
#    instance_type = "t2.micro"
#    iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
#    subnet_id = module.secondary_sbtphapp_vpc.database_subnet_id
#    instance_sg_id = module.secondary_sbtphapp_vpc.database_sg_id
#    instance_bootup_script = "db_instance_bootup_script.yaml"

   
# }

# module "secondary_sbtphapp_backend_instance" {
#    source  = "./ec2"
#    providers  = {
#         aws = aws.secondary
#     }
#    mysql_app_user = var.mysql_app_user
#    mysql_app_pwd =  var.mysql_app_pwd 
#    mysql_rep_user = var.mysql_rep_user 
#    mysql_rep_pwd  = var.mysql_rep_pwd 
#    region =  "us-east-2"
#    instance_name = "Backend"
#    instance_type = "t2.micro"
#    iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
#    subnet_id = module.secondary_sbtphapp_vpc.backend_subnet_id
#    instance_sg_id = module.secondary_sbtphapp_vpc.backend_sg_id
#    instance_bootup_script = "backend_instance_bootup_script.yaml"

#    depends_on = [ module.secondary_sbtphapp_db_instance ]


# }

# module "secondary_sbtphapp_frontend_instance" {
#    source  = "./ec2"
#    providers  = {
#         aws = aws.secondary
#     }
#    mysql_app_user = var.mysql_app_user
#    mysql_app_pwd =  var.mysql_app_pwd 
#    mysql_rep_user = var.mysql_rep_user 
#    mysql_rep_pwd  = var.mysql_rep_pwd 

#    region =  "us-east-2"
#    instance_name = "Frontend"
#    instance_type = "t2.micro"
#    iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
#    subnet_id = module.secondary_sbtphapp_vpc.frontend_subnet_id
#    instance_sg_id = module.secondary_sbtphapp_vpc.frontend_sg_id
#    instance_bootup_script = "frontend_instance_bootup_script.yaml"

#    depends_on = [ module.secondary_sbtphapp_backend_instance ]


# }

# module "secondary_sbtphapp_make_db_private_lambda" {

#       providers  = {
#         aws = aws.secondary
#     }
#     source = "./lambda/makeprivate"
#     sbtphapp_lambda_role_arn = module.sbtphapp_iam.sbtphapp_lambda_role_arn
#     vpc_id = module.secondary_sbtphapp_vpc.vpc_id
#     database_subnet_id = module.secondary_sbtphapp_vpc.database_subnet_id

#     depends_on = [ module.secondary_sbtphapp_vpc, module.sbtphapp_iam, module.secondary_sbtphapp_frontend_instance ]
# }



# resource "aws_vpc_peering_connection" "sbtphapp_vpc_peering" {
#     peer_vpic_id =  module.secondary_sbtphapp_vpc.vpc_id
#     vpc_id = module.primary_sbtphapp_vpc.vpc_id
#     auto_accept = true

#     tags = {
#         Name  = "sbtphapp_vpc_peering"
#     }

#     depends_on = [
#          module.primary_sbtphapp_vpc,
#          module.secondary_sbtphapp_vpc,
         
#     ]

# }


# output "sbtphapp_lambda_role_arn" {
#     value = module.sbtphapp_iam.sbtphapp_lambda_role_arn
# }

# output "sbtphapp_instance_profile_name" {
#     value = module.sbtphapp_iam.sbtphapp_instance_profile_name
# }

# output "vpc_id" {
#    value = module.primary_sbtphapp_vpc.vpc_id
# }

# output "frontend_subnet_id" {
#     value = module.primary_sbtphapp_vpc.frontend_subnet_id
# }

# output "backend_subnet_id" {
#     value = module.primary_sbtphapp_vpc.backend_subnet_id
# }

# output "database_subnet_id" {
#     value = module.primary_sbtphapp_vpc.database_subnet_id
# }

# output "database_sg_id" {
#     value = module.primary_sbtphapp_vpc.database_sg_id
# }

# output "frontend_sg_id" {
#     value = module.primary_sbtphapp_vpc.frontend_sg_id
# }

# output "backend_sg_id" {
#     value = module.primary_sbtphapp_vpc.backend_sg_id
# }


# output "sbtphapp_public_rt_id" {
#     value = module.primary_sbtphapp_vpc.sbtphapp_public_rt_id
# }

# output "made_db_public_invoke_result" {
#     value =  module.primary_make_db_public_lambda.made_db_public_invoke_result
# }