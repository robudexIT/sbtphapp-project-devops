resource "aws_vpc" "sbtphapp_vpc" {
   cidr_block = var.vpc_cidr_block[var.region]
   enable_dns_hostnames = true
   enable_dns_support = true
   tags = {
    Name = var.vpc_name
   }
}


resource "aws_internet_gateway" "sbtphapp_igw" {
    vpc_id = aws_vpc.sbtphapp_vpc.id 

    tags = {
        Name = "${var.vpc_name}-sbtphapp-igw"
    }
}

resource "aws_route_table" "sbtphapp_public_rt" {
    vpc_id = aws_vpc.sbtphapp_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sbtphapp_igw.id
    }
    tags = {
      Name = "${var.vpc_name}-publicRT"
    }
}

resource "aws_route_table" "sbtphapp_private_rt" {
    vpc_id = aws_vpc.sbtphapp_vpc.id
    
    tags = {
      Name = "${var.vpc_name}-privateRT"
    }
}




data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_subnet" "frontend_subnet01" {
  count = var.region == "us-east-1" ? 1 : 0
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[0]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[0]]
  map_public_ip_on_launch = true
  tags = {
    Name = "frontend_subnet01"
  }
}

resource "aws_subnet" "frontend_subnet02" {
  count = var.region == "us-east-1" ? 1 : 0
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[1]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[1]]
  map_public_ip_on_launch = true
  tags = {
    Name = "frontend_subnet02"
  }
}


resource "aws_subnet" "backend_subnet01" {
  count = var.region == "us-east-1" ? 1 : 0
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[2]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[2]]
  map_public_ip_on_launch = true

  tags = {
    Name = "backend_subnet01"
  }

}

resource "aws_subnet" "backend_subnet02" {
  count = var.region == "us-east-1" ? 1 : 0
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[3]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[3]]
  map_public_ip_on_launch = true

  tags = {
    Name = "backend_subnet02"
  }

}

resource "aws_subnet" "database_subnet01" {
  count = var.region == "us-east-1" ? 1 : 0
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[4]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[4]]
  map_public_ip_on_launch = false

    tags = { 
    Name = "database_subnet01"
  }


}

resource "aws_subnet" "database_subnet02" {
  count = var.region == "us-east-1" ? 1 : 0
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[5]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[5]]
  map_public_ip_on_launch = false

    tags = { 
    Name = "database_subnet02"
  }


 }

resource "aws_subnet" "database_replica_subnet01" {
  count = var.region == "us-east-2" ? 1 : 0
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[0]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[0]]
  map_public_ip_on_launch = false

    tags = { 
    Name = "database_replica_subnet01"
  }


}

resource "aws_subnet" "database_replica_subnet02" {
  count = var.region == "us-east-2" ? 1 : 0
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[1]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[1]]
  map_public_ip_on_launch = false

    tags = { 
    Name = "database_replica_subnet02"
  }


}

resource "aws_db_subnet_group" "aws_db_subnet_group_region1" {
    count = var.region == "us-east-1" ? 1 : 0
    name = "aws_db_subnet_group_region1"
    subnet_ids = [aws_subnet.database_subnet01[0].id, aws_subnet.database_subnet02[0].id]
    tags =  {
      Name = "aws_db_subnet_group_region1"
    }
}



resource "aws_db_subnet_group" "aws_db_subnet_group_region2" {
    count = var.region == "us-east-2" ? 1 : 0 
    name = "aws_db_subnet_group_region2"
    subnet_ids = [aws_subnet.database_replica_subnet01[0].id, aws_subnet.database_replica_subnet02[0].id]
    tags =  {
      Name = "aws_db_subnet_group_region2"
    }
}




resource "aws_route_table_association" "sbtphapp_public_rt_assoc_backend_subnet01" {
    count = var.region == "us-east-1" ? 1 : 0
    subnet_id = aws_subnet.backend_subnet01[0].id
    route_table_id = aws_route_table.sbtphapp_public_rt.id
}

resource "aws_route_table_association" "sbtphapp_public_rt_assoc_backend_subnet02" {
  count = var.region == "us-east-1" ? 1 : 0
    subnet_id = aws_subnet.backend_subnet02[0].id
    route_table_id = aws_route_table.sbtphapp_public_rt.id
}


resource "aws_route_table_association" "sbtphapp_public_rt_assoc_frontend_subnet01" {
  count = var.region == "us-east-1" ? 1 : 0
  subnet_id = aws_subnet.frontend_subnet01[0].id
  route_table_id = aws_route_table.sbtphapp_public_rt.id
}

resource "aws_route_table_association" "sbtphapp_public_rt_assoc_frontend_subnet02" {
  count = var.region == "us-east-1" ? 1 : 0 
  subnet_id = aws_subnet.frontend_subnet02[0].id
  route_table_id = aws_route_table.sbtphapp_public_rt.id
}


resource "aws_route_table_association" "sbtphapp_private_rt_assoc_database_subnet01" {
  count = var.region == "us-east-1" ? 1 : 0 
  subnet_id = aws_subnet.database_subnet01[0].id
  route_table_id = aws_route_table.sbtphapp_private_rt.id
}

resource "aws_route_table_association" "sbtphapp_private_rt_assoc_database_subnet02" {
  count = var.region == "us-east-1" ? 1 : 0 
  subnet_id = aws_subnet.database_subnet02[0].id
  route_table_id = aws_route_table.sbtphapp_private_rt.id
}

resource "aws_route_table_association" "sbtphapp_private_rt_assoc_database_replica_subnet01" {
  count = var.region == "us-east-2" ? 1 : 0 
  subnet_id = aws_subnet.database_replica_subnet01[0].id
  route_table_id = aws_route_table.sbtphapp_private_rt.id
}


resource "aws_route_table_association" "sbtphapp_private_rt_assoc_database_replica_subnet02" {
  count = var.region == "us-east-2" ? 1 : 0 
  subnet_id = aws_subnet.database_replica_subnet02[0].id
  route_table_id = aws_route_table.sbtphapp_private_rt.id
}





resource "aws_security_group" "frontend_sg" {
   count = var.region == "us-east-1" ? 1 : 0
    name = "frontend_sg"
    description = "Security Group for Frontend Instance"
    vpc_id = aws_vpc.sbtphapp_vpc.id 

    ingress {
        description = "Allowed SSH access to trusted to this ip address"
        from_port = 22
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = [var.ssh_location]

    }

    ingress {
        description = "Allowed Http to any ip address source"
        from_port = 80 
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description= "Allowed all traffic from database_sg"
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

      tags = {
       Name = "frontend_sg"
     }


}

resource "aws_security_group" "frontend_elb_sg" {
   count = var.region == "us-east-1" ? 1 : 0
   name = "frontend_elb_sg"
   description = "Security Groupt of Frontend Loadbalancing"
   vpc_id = aws_vpc.sbtphapp_vpc.id

   ingress {
        description = "Allowed Port 80 from the outside world"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]

   }
   ingress {
        description = "Allowed Port 443 from the outside world"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]

   }

  egress {
          from_port        = 0
          to_port          = 0
          protocol         = "-1"
          cidr_blocks      = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
      }

  tags = {
       Name = "frontend_elb_sg"
     }

    
}

resource "aws_security_group" "backend_sg" {
   count = var.region == "us-east-1" ? 1 : 0
    name = "backend_sg"
    description = "Security Group for Backend Instance"
    vpc_id = aws_vpc.sbtphapp_vpc.id 

    ingress {
        description = "Allowed SSH access to trusted to this ip address"
        from_port = 22
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = [var.ssh_location]

    }

    ingress {
        description= "Allowed Http to any ip address source"
        from_port = 80 
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


     ingress {
        description= "Allowed all traffic from it self"
        from_port = 0
        to_port =  0
        protocol = "-1"
        self = true
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

     tags = {
       Name = "backend_sg"
     }


}

resource "aws_security_group" "backend_elb_sg" {
  count = var.region == "us-east-1" ? 1 : 0

   name = "backend_elb_sg"
   description = "Security Groupt of Backtend Loadbalancing"
   vpc_id = aws_vpc.sbtphapp_vpc.id

   ingress {
        description = "Allowed Port 80 from the outside world"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]

   }
   ingress {
        description = "Allowed Port 443 from the outside world"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]

   }

    egress {
          from_port        = 0
          to_port          = 0
          protocol         = "-1"
          cidr_blocks      = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
      }

      tags = {
       Name = "backend_elb_sg"
     }

    
}



resource "aws_security_group" "database_sg" {
    name = "database_sg"
    description = "Security Group for Database Instance"
    vpc_id = aws_vpc.sbtphapp_vpc.id 

    ingress {
        description = "Allowed SSH access to trusted to this ip address"
        from_port = 22
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = [var.ssh_location]

    }



      ingress {
        description= "Allowed all traffic from itself"
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }




    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

     tags = {
       Name = "database_sg"
     }


}

resource "aws_security_group" "database_allow_peer_subnet_sg" {
    name = "database_allow_peer_subnet_sg"
    description = "Allow Other Region Database Subnet "
    vpc_id = aws_vpc.sbtphapp_vpc.id 
}

resource "aws_security_group_rule" "allow_backend_sg" {
  count = var.region == "us-east-1" ? 1 : 0
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = aws_security_group.backend_sg[0].id
  security_group_id = aws_security_group.database_sg.id
}



output "vpc_id" {
   value = aws_vpc.sbtphapp_vpc.id
}

output "frontend_subnet01_id" {
    value =  var.region == "us-east-1" ? aws_subnet.frontend_subnet01[0].id : null
}
output "frontend_subnet02_id" {
    value = var.region == "us-east-1" ? aws_subnet.frontend_subnet02[0].id : null
}

output "backend_subnet01_id" {
    value = var.region == "us-east-1" ? aws_subnet.backend_subnet01[0].id : null
}

output "backend_subnet02_id" {
    value = var.region == "us-east-1" ? aws_subnet.backend_subnet02[0].id : null
}

output "database_subnet01_id" {
    value = var.region == "us-east-1" ? aws_subnet.database_subnet01[0].id : null
}

output "database_subnet02_id" {
    value = var.region == "us-east-1" ? aws_subnet.database_subnet02[0].id : null
}

output "database_replica_subnet01_id" {
    value = var.region == "us-east-2" ? aws_subnet.database_replica_subnet01[0].id : null
}

output "database_replica_subnet02_id" {
    value = var.region == "us-east-2" ? aws_subnet.database_replica_subnet02[0].id : null
}

output "database_sg_id" {
    value = aws_security_group.database_sg.id
}

output "database_allow_peer_subnet_sg" {
    value = aws_security_group.database_allow_peer_subnet_sg.id
}


output "frontend_sg_id" {
    value = var.region == "us-east-1" ? aws_security_group.frontend_sg[0].id : null
}

output "backend_sg_id" {
    value = var.region == "us-east-1" ? aws_security_group.backend_sg[0].id : null
}

output "backend_elb_sg_id" {
    value = var.region == "us-east-1" ? aws_security_group.backend_elb_sg[0].id : null
}

output "frontend_elb_sg_id" {
    value = var.region == "us-east-1" ? aws_security_group.frontend_elb_sg[0].id : null
}

output "aws_db_subnet_group_region1_name" {
    value = var.region == "us-east-1" ? aws_db_subnet_group.aws_db_subnet_group_region1[0].id :null
}    

output "aws_db_subnet_group_region2_name" {
    value =  var.region == "us-east-2" ? aws_db_subnet_group.aws_db_subnet_group_region2[0].id : null
}


output "sbtphapp_public_rt_id" {
    value = aws_route_table.sbtphapp_public_rt.id
}

output "sbtphapp_private_rt_id" {
    value = aws_route_table.sbtphapp_private_rt.id
}




