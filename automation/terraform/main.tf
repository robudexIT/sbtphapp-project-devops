
module "sbtphapp_iam" {
    source = "./iam"

}
module "primary_sbtphapp_vpc" {
    source = "./vpc"
    region = "us-east-1"
    vpc_name = "primary_sbtphapp_vpc"
    depends_on = [ module.sbtphapp_iam ]

}

module "secondary_sbtphapp_vpc" {
    providers  = {
        aws = aws.secondary
    }
    source = "./vpc"
    region = "us-east-2"
    vpc_name = "secondary_sbtphapp_vpc"
    depends_on = [ module.sbtphapp_iam]
}

resource "aws_vpc_peering_connection" "sbtphapp_vpc_requester" {
  vpc_id        =  module.primary_sbtphapp_vpc.vpc_id
  peer_vpc_id   = module.secondary_sbtphapp_vpc.vpc_id
  peer_region   = "us-east-2"
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "sbtphapp_vpc_accepter" {
 provider =  aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.sbtphapp_vpc_requester.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

data "aws_subnet" "primary_database_subnet" {
  id = module.primary_sbtphapp_vpc.database_subnet_id
}

data "aws_subnet" "secondary_database_subnet" {
  provider = aws.secondary
  id = module.secondary_sbtphapp_vpc.database_subnet_id
}


resource "aws_route" "route_to_secondary_db_cidr" {
    route_table_id  = module.primary_sbtphapp_vpc.sbtphapp_public_rt_id
    vpc_peering_connection_id =  aws_vpc_peering_connection.sbtphapp_vpc_requester.id
    destination_cidr_block  = data.aws_subnet.secondary_database_subnet.cidr_block
    depends_on = [ aws_vpc_peering_connection_accepter.sbtphapp_vpc_accepter ]
}

resource "aws_security_group_rule" "primary_database_sg" {
  type              = "ingress"
  description= "Allowed all traffic from database subnet of another region"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.aws_subnet.secondary_database_subnet.cidr_block]
  security_group_id =  module.primary_sbtphapp_vpc.database_sg_id
}

resource "aws_route" "route_to_primary_db_cidr" {
    provider =  aws.secondary
    route_table_id  = module.secondary_sbtphapp_vpc.sbtphapp_public_rt_id
    vpc_peering_connection_id =  aws_vpc_peering_connection.sbtphapp_vpc_requester.id
    destination_cidr_block  = data.aws_subnet.primary_database_subnet.cidr_block
    depends_on = [ aws_vpc_peering_connection_accepter.sbtphapp_vpc_accepter  ]
}

resource "aws_security_group_rule" "secondary_database_sg" {
  provider =  aws.secondary  
  type              = "ingress"
  description= "Allowed all traffic from database subnet of another region"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.aws_subnet.primary_database_subnet.cidr_block]

  security_group_id =  module.secondary_sbtphapp_vpc.database_sg_id
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



module "secondary_sbtphapp_db_instance" {
   source  = "./ec2"
   providers  = {
        aws = aws.secondary
    }
   mysql_app_user = var.mysql_app_user
   mysql_app_pwd =  var.mysql_app_pwd 
   mysql_rep_user = var.mysql_rep_user 
   mysql_rep_pwd  = var.mysql_rep_pwd 
  
   region =  "us-east-2"
   instance_name = "Database"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.secondary_sbtphapp_vpc.database_subnet_id
   instance_sg_id = module.secondary_sbtphapp_vpc.database_sg_id
   instance_bootup_script = "db_instance_bootup_script.yaml"

   
}

module "secondary_sbtphapp_backend_instance" {
   source  = "./ec2"
   providers  = {
        aws = aws.secondary
    }
   mysql_app_user = var.mysql_app_user
   mysql_app_pwd =  var.mysql_app_pwd 
   mysql_rep_user = var.mysql_rep_user 
   mysql_rep_pwd  = var.mysql_rep_pwd 
   region =  "us-east-2"
   instance_name = "Backend"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.secondary_sbtphapp_vpc.backend_subnet_id
   instance_sg_id = module.secondary_sbtphapp_vpc.backend_sg_id
   instance_bootup_script = "backend_instance_bootup_script.yaml"

   depends_on = [ module.secondary_sbtphapp_db_instance ]


}

module "secondary_sbtphapp_frontend_instance" {
   source  = "./ec2"
   providers  = {
        aws = aws.secondary
    }
   mysql_app_user = var.mysql_app_user
   mysql_app_pwd =  var.mysql_app_pwd 
   mysql_rep_user = var.mysql_rep_user 
   mysql_rep_pwd  = var.mysql_rep_pwd 

   region =  "us-east-2"
   instance_name = "Frontend"
   instance_type = "t2.micro"
   iam_instance_profile = module.sbtphapp_iam.sbtphapp_instance_profile_name
   subnet_id = module.secondary_sbtphapp_vpc.frontend_subnet_id
   instance_sg_id = module.secondary_sbtphapp_vpc.frontend_sg_id
   instance_bootup_script = "frontend_instance_bootup_script.yaml"

   depends_on = [ module.secondary_sbtphapp_backend_instance ]


}






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

# output "made_db_public_invoke_result" {
#     value =  module.primary_make_db_public_lambda.made_db_public_invoke_result
# }