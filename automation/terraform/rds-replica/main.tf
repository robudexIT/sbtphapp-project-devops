resource "aws_db_instance" "replicadbinstance" {
  identifier = var.db_identifier
  replicate_source_db  = var.replicate_source_db
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.db_instance_class

  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name  = var.db_subnet_group_name
  vpc_security_group_ids = [var.database_sg_id, var.database_allow_peer_subnet_sg]
  backup_retention_period = 1
  publicly_accessible =  false
  multi_az  = false 

  skip_final_snapshot  = true
  tags = {
    Name = "replicadbinstance"
  }
}

output "replicadbinstance_arn" {
    value = aws_db_instance.replicadbinstance.arn
}

output "replicadbinstance_address" {
    value = aws_db_instance.replicadbinstance.address
}