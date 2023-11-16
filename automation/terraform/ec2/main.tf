resource "aws_launch_template" "sbtphap_launch_template" {
  name = var.launch_template_name
  description = var.launch_template_description
  image_id = var.ami_ubuntu204[var.region]
  instance_type = var.instance_type
  key_name = var.ec2_instance_keypair[var.region]
  vpc_security_group_ids = [var.launch_template_sg_id]
  
  user_data =  base64encode(templatefile("ec2/scripts/${var.instance_bootup_script}", {
        mysql_app_user = var.mysql_app_user
        mysql_app_pwd =  var.mysql_app_pwd
        db_host_ip = var.db_host_ip
        aws_region =  var.region,
        backend_api_https = "https://${var.backend_subdomain}.${var.registered_domain}"

    }))

  tags = {
    Name = var.launch_template_name
  }

}

resource "aws_lb_target_group" "sbtphapp_target_group" {
  name = var.target_group_name
  
  vpc_id = var.vpc_id
  target_type = "instance"
  ip_address_type = "ipv4"
  port = var.target_group_port
  protocol = var.target_group_protocol
  health_check {
    port = var.target_group_port
    protocol = var.target_group_protocol
    path = "/"
  }
  tags = {
    Name = var.target_group_name
  }


}

resource "aws_lb" "sbtphapp_loadbalancer" {
  name = var.load_balancer_name
  load_balancer_type = "application"
  security_groups = [ var.load_balancer_sg]
  subnets = [var.load_balancer_subnet01, var.load_balancer_subnet02]
  ip_address_type = "ipv4"
  internal =  false


  tags = {
    Name = var.load_balancer_name
  }

}

resource "aws_lb_listener" "sbtph_lb_listener" {
  load_balancer_arn = aws_lb.sbtphapp_loadbalancer.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn

   default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sbtphapp_target_group.arn
  }

}


# resource "aws_lb_target_group_attachment" "sbtphap_alb_targetgroup_attachement" {
#    target_group_arn = aws_lb_target_group.sbtphapp_target_group.arn
#    target_id = aws_lb.sbtphapp_loadbalancer.arn
# }

resource "aws_autoscaling_group" "sbtph_asg" {
   name = var.aws_autoscaling_group_name 
   max_size = 1
   min_size = 1
   health_check_grace_period = 300
   desired_capacity = 1
   launch_template {
    id      = aws_launch_template.sbtphap_launch_template.id
    version = "$Latest"
  }
   target_group_arns = [aws_lb_target_group.sbtphapp_target_group.arn]
   vpc_zone_identifier = [var.asg_subnet01_id, var.asg_subnet02_id]
   health_check_type =  "ELB"


}

output "sbtphapp_loadbalancer_dns_name" {
  value = aws_lb.sbtphapp_loadbalancer.dns_name
}