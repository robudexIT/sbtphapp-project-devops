**In This section,  we are going to build the (lift-and-shift) project using another powerful IAAC technology called Terraform.
The infrastructure is the same, but this time instead of using Cloudformation we used Terraform.**

**Notes: <br />**
  1. For simplicity, I don't include any lambda function, as I did in the Cloudformation section.
  2. Before building this project, please make sure that you have awscli installed on your local machine with Administrator **access-key** credentials.
  3. This project  is tested in region **us-east-1** as the primary and region **us-east-2** as the secondary

**Instructions:** <br />
  1. First thing first, you  need to install the Terraform software on your local machine. Here's the link on how to install it based on the Operating System that you are using **https://developer.hashicorp.com/terraform/downloads?product_intent=terraform**
  2. clone this repository (_git clone -b  lift-and-shift https://github.com/robudexIT/sbtphapp-project-devops.git_)
  3. Create EC2 keypair for ssh access on instance. For us-east-1 keyname: primary-ec2-keypair <br > For us-east-2 keyname: backup-ec2-keypair <br /> Save the keypairs on your local machine and modify the permission <br / > chmod 400 primary-ec2-keypair.pem <br  /> chmod 400 backup-ec2-keypair.pem
  4. go to the **automation/terraform** section of the project (_cd sbtphapp-project-devops/automation/terraform_)
  5. open the **variables.tfvars** files and replace the mysql credentials on the file.
  6. Under **sbtphapp-project-devops/automation/terraform:** run the command: <br />
     1. terraform init <br />
     2. terraform plan -var-file=variables.tfvars  <br />
     3. terraform apply -var-file=variables.tfvars  -auto-approve <br />
  7. Wait for the terraform to finish creating the resources. When it's done, log in to your AWS account and check the resources created by the terraform.
