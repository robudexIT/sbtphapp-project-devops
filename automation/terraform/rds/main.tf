resource "aws_db_instance" "primarydbinstance" {
  identifier = var.db_identifier
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.db_instance_class
  username             = var.mysql_app_user
  password             = var.mysql_app_pwd
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name  = var.db_subnet_group_name
  vpc_security_group_ids = [var.database_sg_id, var.database_allow_peer_subnet_sg]
  backup_retention_period = 1
  publicly_accessible =  false
  multi_az  = false 

  skip_final_snapshot  = true
  tags = {
    Name = "primarydbinstance"
  }
}

output "primarydbinstance_arn" {
    value = aws_db_instance.primarydbinstance.arn
}

output "primarydbinstance_address" {
    value = aws_db_instance.primarydbinstance.address
}