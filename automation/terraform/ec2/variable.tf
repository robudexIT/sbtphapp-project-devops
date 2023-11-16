variable "region" {
  type = string
}

variable "ami_ubuntu204" {
  type  = map 
  default = {
    us-east-1 = "ami-0261755bbcb8c4a84"
    us-east-2 = "ami-0430580de6244e02e"
  }
}

variable "ec2_instance_keypair" {
  type = map 
  default = {
    us-east-1 = "primary-ec2-keypair"
    us-east-2 = "backup-ec2-keypair"
  }
}


variable "instance_type" {
    type = string 
    default = "t2.micro"
}

variable "instance_bootup_script" {
    type = string
}

variable "mysql_app_user" {
    type = string
}

variable "mysql_app_pwd" {
    type = string
}

variable "db_host_ip"{
  type = string
}



variable "vpc_id" {
  type = string 
  default = ""
}

variable "function_name" {
  type = string 
  default = ""
}

variable "database_subnet_id" {
  type = string 
  default = ""
}

variable "launch_template_name" {
  type = string

}

variable "launch_template_description" {
  type = string
}

variable "launch_template_sg_id" {
  type = string 
}

variable "target_group_name" {
  type = string
}

variable "target_group_port" {
  type = number
  
}

variable "target_group_protocol" {
  type = string
}

variable "load_balancer_name" {
  type = string 
}

variable "load_balancer_sg" {
  type = string
}

variable "load_balancer_subnet01"{
  type = string
}

variable "load_balancer_subnet02" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "asg_subnet01_id" {
  type = string
}

variable "asg_subnet02_id" {
  type = string
}
variable "aws_autoscaling_group_name" {
  type = string
}

variable "backend_subdomain" {
   type = string
   
}

variable "frontend_subdomain" {
  type = string
 
}

variable "registered_domain" {
  type = string
  
}


