variable "region" {
  type = string 
  default = "us-east-1"
}

variable "database_sg_id" {
   type = string 
}

variable "database_allow_peer_subnet_sg" {
   type = string
}

variable "db_subnet_group_name" {
   type = string 
}

variable "mysql_app_user" {
  type = string
}

variable "mysql_app_pwd" {
    type = string 
}

variable "db_identifier" {
    type = string
}

variable "db_instance_class" {
    type = string
}


