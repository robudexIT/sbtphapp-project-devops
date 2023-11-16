
data "aws_caller_identity" "current" {}



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

module "primarydbinstance" {
    depends_on = [module.primary_sbtphapp_vpc]
    source = "./rds"
    region = "us-east-1"
    db_subnet_group_name = module.primary_sbtphapp_vpc.aws_db_subnet_group_region1_name
    
    mysql_app_user = var.mysql_app_user
    mysql_app_pwd =  var.mysql_app_pwd 
    db_instance_class = var.db_instance_class
    db_identifier = var.primary_db_identifier
    database_sg_id = module.primary_sbtphapp_vpc.database_sg_id
    database_allow_peer_subnet_sg = module.primary_sbtphapp_vpc.database_allow_peer_subnet_sg
  

}


module "primary_sbtphapp_backend_instance" {
   source  = "./ec2"
   mysql_app_user = var.mysql_app_user
   mysql_app_pwd =  var.mysql_app_pwd 
   frontend_subdomain = var.frontend_subdomain
   backend_subdomain = var.backend_subdomain
   registered_domain = var.registered_domain 
#    mysql_rep_user = var.mysql_rep_user 
#    mysql_rep_pwd  = var.mysql_rep_pwd 
   db_host_ip = module.primarydbinstance.primarydbinstance_address
   region =  "us-east-1"
   vpc_id = module.primary_sbtphapp_vpc.vpc_id
   instance_type = "t2.micro"
   
   instance_bootup_script = "backend_instance_bootup_script.sh"
   launch_template_name = "backend_launch_template"
   launch_template_description = "Launch Template for backend instance"
   launch_template_sg_id = module.primary_sbtphapp_vpc.backend_sg_id

   target_group_name = "backend-target-group"
   target_group_port = 80
   target_group_protocol = "HTTP"
   
   load_balancer_name = "backend-load-balancer"
   load_balancer_sg = module.primary_sbtphapp_vpc.backend_elb_sg_id
   load_balancer_subnet01 = module.primary_sbtphapp_vpc.backend_subnet01_id
   load_balancer_subnet02 = module.primary_sbtphapp_vpc.backend_subnet02_id
   certificate_arn = var.certificate_arn 
   
   aws_autoscaling_group_name = "backend-asg"
   asg_subnet01_id = module.primary_sbtphapp_vpc.backend_subnet01_id
   asg_subnet02_id = module.primary_sbtphapp_vpc.backend_subnet02_id
   depends_on = [ module.primarydbinstance ]

}

module "primary_sbtphapp_frontend_instance" {
   source  = "./ec2"
   mysql_app_user = var.mysql_app_user
   mysql_app_pwd =  var.mysql_app_pwd 
   frontend_subdomain = var.frontend_subdomain
   backend_subdomain = var.backend_subdomain
   registered_domain = var.registered_domain 

#    mysql_rep_user = var.mysql_rep_user 
#    mysql_rep_pwd  = var.mysql_rep_pwd 
   db_host_ip = module.primarydbinstance.primarydbinstance_address
   region =  "us-east-1"
   vpc_id = module.primary_sbtphapp_vpc.vpc_id
   instance_type = "t2.micro"
   
   instance_bootup_script = "frontend_instance_bootup_script.sh"
   launch_template_name = "frontend_launch_template"
   launch_template_description = "Launch Template for frontend instance"
   launch_template_sg_id = module.primary_sbtphapp_vpc.frontend_sg_id

   target_group_name = "frontend-target-group"
   target_group_port = 80
   target_group_protocol = "HTTP"
   
   load_balancer_name = "frontend-load-balancer"
   load_balancer_sg = module.primary_sbtphapp_vpc.frontend_elb_sg_id
   load_balancer_subnet01 = module.primary_sbtphapp_vpc.frontend_subnet01_id
   load_balancer_subnet02 = module.primary_sbtphapp_vpc.frontend_subnet02_id
   certificate_arn = var.certificate_arn
   
   aws_autoscaling_group_name = "frontend-asg"
   asg_subnet01_id = module.primary_sbtphapp_vpc.frontend_subnet01_id
   asg_subnet02_id = module.primary_sbtphapp_vpc.frontend_subnet02_id

   
   depends_on = [ module.primary_sbtphapp_vpc ]

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

data "aws_subnet" "primary_database_subnet01" {
  id = module.primary_sbtphapp_vpc.database_subnet01_id
}

data "aws_subnet" "primary_database_subnet02" {
  id = module.primary_sbtphapp_vpc.database_subnet02_id
}


data "aws_subnet" "database_replica_subnet01" {
  provider = aws.secondary
  id = module.secondary_sbtphapp_vpc.database_replica_subnet01_id
}

data "aws_subnet" "database_replica_subnet02" {
  provider = aws.secondary
  id = module.secondary_sbtphapp_vpc.database_replica_subnet02_id
}



resource "aws_route" "route_to_database_replica_subnet01_cidr" {
    route_table_id  = module.primary_sbtphapp_vpc.sbtphapp_private_rt_id
    vpc_peering_connection_id =  aws_vpc_peering_connection.sbtphapp_vpc_requester.id
    destination_cidr_block  = data.aws_subnet.database_replica_subnet01.cidr_block
    depends_on = [ aws_vpc_peering_connection_accepter.sbtphapp_vpc_accepter ]
}

resource "aws_route" "route_to_database_replica_subnet02_cidr" {
    route_table_id  = module.primary_sbtphapp_vpc.sbtphapp_private_rt_id
    vpc_peering_connection_id =  aws_vpc_peering_connection.sbtphapp_vpc_requester.id
    destination_cidr_block  = data.aws_subnet.database_replica_subnet02.cidr_block
    depends_on = [ aws_vpc_peering_connection_accepter.sbtphapp_vpc_accepter ]
}

resource "aws_security_group_rule" "primary_database_sg" {
  type              = "ingress"
  description= "Allowed all traffic from database subnet of another region"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.aws_subnet.database_replica_subnet01.cidr_block, data.aws_subnet.database_replica_subnet02.cidr_block]
  security_group_id =  module.primary_sbtphapp_vpc.database_allow_peer_subnet_sg
}

resource "aws_route" "route_to_primary_database_subnet01_cidr" {
    provider =  aws.secondary
    route_table_id  = module.secondary_sbtphapp_vpc.sbtphapp_private_rt_id
    vpc_peering_connection_id =  aws_vpc_peering_connection.sbtphapp_vpc_requester.id
    destination_cidr_block  = data.aws_subnet.primary_database_subnet01.cidr_block
    depends_on = [ aws_vpc_peering_connection_accepter.sbtphapp_vpc_accepter  ]
}

resource "aws_route" "route_to_primary_database_subnet02_cidr" {
    provider =  aws.secondary
    route_table_id  = module.secondary_sbtphapp_vpc.sbtphapp_private_rt_id
    vpc_peering_connection_id =  aws_vpc_peering_connection.sbtphapp_vpc_requester.id
    destination_cidr_block  = data.aws_subnet.primary_database_subnet02.cidr_block
    depends_on = [ aws_vpc_peering_connection_accepter.sbtphapp_vpc_accepter  ]
}

resource "aws_security_group_rule" "secondary_database_sg" {
  provider =  aws.secondary  
  type              = "ingress"
  description= "Allowed all traffic from database subnet of another region"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.aws_subnet.primary_database_subnet01.cidr_block,data.aws_subnet.primary_database_subnet02.cidr_block]

  security_group_id =  module.secondary_sbtphapp_vpc.database_allow_peer_subnet_sg
}


module "replicadbinstance" {
      providers  = {
        aws = aws.secondary
    }
    depends_on = [module.secondary_sbtphapp_vpc, module.primarydbinstance]
    source = "./rds-replica"
    region = "us-east-1"
    db_subnet_group_name = module.secondary_sbtphapp_vpc.aws_db_subnet_group_region2_name
    
    db_instance_class = var.db_instance_class
    db_identifier = var.replica_db_identifier
    replicate_source_db = "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:${var.primary_db_identifier}"
    database_sg_id = module.secondary_sbtphapp_vpc.database_sg_id
    database_allow_peer_subnet_sg = module.secondary_sbtphapp_vpc.database_allow_peer_subnet_sg
  

}


output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "backend_subdomain" {
    value = var.backend_subdomain
}

output "sbtphapp_backend_loadbalancer_dns_name"{
    value = module.primary_sbtphapp_backend_instance.sbtphapp_loadbalancer_dns_name
}


output "backend_fqdn" {
 value = "https://${var.backend_subdomain}.${var.registered_domain}"
}


output "frontend_subdomain" {
    value = var.frontend_subdomain
}

output "sbtphapp_frontend_loadbalancer_dns_name"{
    value = module.primary_sbtphapp_frontend_instance.sbtphapp_loadbalancer_dns_name
}

output "frontend_fqdn" {
  value = "https://${var.frontend_subdomain}.${var.registered_domain}"
}








