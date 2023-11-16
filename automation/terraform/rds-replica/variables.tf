variable "region" {
  type = string 
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


variable "replicate_source_db" {
    type = string 
}

variable "db_identifier" {
    type = string
}

variable "db_instance_class" {
    type = string
}


