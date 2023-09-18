variable "region" {
  type = string 
  default = "us-east-1"
}

variable "vpc_name" {
  type = string 
  default = "sbtphapp_vpc"
}
variable "vpc_cidr_block" {
  type = map
  default = {
    us-east-1 = "192.168.0.0/16"
    us-east-2 = "172.16.0.0/16"
  }
}

variable "az_subent_cidr_block" {
  type = map 
  default = {
    us-east-1a = "192.168.1.0/24"
    us-east-1b = "192.168.2.0/24"
    us-east-1c = "192.168.50.0/24"
    us-east-2a = "172.16.1.0/24"
    us-east-2b = "172.16.2.0/24"
    us-east-2c = "172.16.50.0/24"
  }
}


# variable "ubuntu_ami_20_4" {
#   type = map
#   default = {
#       us-east-1 = ""
#       us-east-2 = ""
#   }

# }

variable "ssh_location" {
  type = string 
  default = "0.0.0.0/0"
}


