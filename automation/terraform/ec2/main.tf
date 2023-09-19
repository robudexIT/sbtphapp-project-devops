data "cloudinit_config" "server_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("ec2/scripts/${var.instance_bootup_script}", {
        mysql_app_user = var.mysql_app_user
        mysql_app_pwd =  var.mysql_app_pwd
        mysql_rep_user = var.mysql_rep_user
        mysql_rep_pwd  = var.mysql_rep_pwd
        aws_region =  var.region
    })
  }
}

resource "aws_instance" "sbtphapp_instance_template" {
  ami = var.ami_ubuntu204[var.region]

  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
    Server = var.instance_name
  }
  iam_instance_profile = var.iam_instance_profile
  key_name = var.ec2_instance_keypair[var.region]

  user_data = data.cloudinit_config.server_config.rendered
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.instance_sg_id]


}