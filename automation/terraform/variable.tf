variable "region" {
  type = string 
  default = "us-east-1"

}

variable "mysql_app_user" {
    type = string
}

variable "mysql_app_pwd" {
    type = string
}


variable "db_instance_class" {
  type = string
}

variable "primary_db_identifier"  {
  type = string 
}

variable "replica_db_identifier" {
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

variable "certificate_arn" {
  type = string
}

