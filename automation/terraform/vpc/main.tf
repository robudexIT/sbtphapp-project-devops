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



data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_subnet" "frontend_subnet" {
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[0]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[0]]
  map_public_ip_on_launch = true
  tags = {
    Name = "frontend_subnet"
  }
}

resource "aws_subnet" "backend_subnet" {
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[1]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[1]]
  map_public_ip_on_launch = true

  tags = {
    Name = "backend_subnet"
  }

}

resource "aws_subnet" "database_subnet" {
  vpc_id  = aws_vpc.sbtphapp_vpc.id
  availability_zone =  data.aws_availability_zones.available.names[2]
  cidr_block =  var.az_subent_cidr_block[data.aws_availability_zones.available.names[2]]
  map_public_ip_on_launch = true

    tags = { 
    Name = "database_subnet"
  }


}

resource "aws_route_table_association" "sbtphapp_public_rt_assoc_backend_subnet" {
    subnet_id = aws_subnet.backend_subnet.id
    route_table_id = aws_route_table.sbtphapp_public_rt.id
}

resource "aws_route_table_association" "sbtphapp_public_rt_assoc_frontend_subnet" {
  subnet_id = aws_subnet.frontend_subnet.id
  route_table_id = aws_route_table.sbtphapp_public_rt.id
}

resource "aws_route_table_association" "sbtphapp_public_rt_assoc_database_subnet" {
  subnet_id = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.sbtphapp_public_rt.id
}

resource "aws_security_group" "frontend_sg" {
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

resource "aws_security_group" "backend_sg" {
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
        description = "Allowed ssh traffic from backend_sg"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.frontend_sg.id]
    }


     ingress {
        description= "Allowed all traffic from database_sg"
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
        description= "Allowed Mysql traffic from backend_sg"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.backend_sg.id]
    }

      ingress {
        description = "Allowed ssh traffic from backend_sg"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.backend_sg.id]
    }

    # ingress {
    #     description= "Allowed all traffic from database subnet of another region"
    #     from_port = 0
    #     to_port = 0
    #     protocol = "-1"
    #     cidr_blocks = [var.other_region_db_cidr]
    # }

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
       Name = "database_sg"
     }


}

output "vpc_id" {
   value = aws_vpc.sbtphapp_vpc.id
}

output "frontend_subnet_id" {
    value = aws_subnet.frontend_subnet.id
}

output "backend_subnet_id" {
    value = aws_subnet.backend_subnet.id
}

output "database_subnet_id" {
    value = aws_subnet.database_subnet.id
}

output "database_sg_id" {
    value = aws_security_group.database_sg.id
}

output "frontend_sg_id" {
    value = aws_security_group.frontend_sg.id
}

output "backend_sg_id" {
    value = aws_security_group.backend_sg.id
}


output "sbtphapp_public_rt_id" {
    value = aws_route_table.sbtphapp_public_rt.id
}



