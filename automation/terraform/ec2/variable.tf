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

variable "instance_name" {
    type = string
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

variable "mysql_rep_user" {
    type = string
}

variable "mysql_rep_pwd" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "iam_instance_profile" {
    type = string
}

variable "instance_sg_id" {
    type = string
}


