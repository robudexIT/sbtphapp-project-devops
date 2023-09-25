**In This section,  we are going to rebuild the below figure (lift-and-shift) project using another powerful  infrastructure-as-code  technology called Terraform.**

![Alt Text](https://github.com/robudexIT/sbtphapp-project-devops/blob/lift-and-shift/sbtphapp_aws_lift_and_shift_architecture.png)

**Notes: <br />**
  1. For simplicity, I don't include any lambda function, as I did in the Cloudformation section.
  2. Before building this project, please make sure that you have awscli installed on your local machine with Administrator **access-key** credentials.
  3. This project  is tested in region **us-east-1** as the primary and region **us-east-2** as the secondary

**Instructions:** <br />
  1. First thing first, you  need to install the Terraform software on your local machine. Here's the link on how to install it based on the Operating System that you are using **https://developer.hashicorp.com/terraform/downloads?product_intent=terraform**
  2. clone this repository (_git clone -b  lift-and-shift https://github.com/robudexIT/sbtphapp-project-devops.git_)
  3. cd to this repository (**cd sbtphapp-project-devops**) this will be your working project directory.
  4. Create EC2 keypair for SSH access on instance. <br />For us-east-1 keyname: **primary-ec2-keypair** <br /> For us-east-2 keyname: **backup-ec2-keypair** <br /> Save the keypairs on your working directory and modify the permission <br /> **chmod 400 primary-ec2-keypair.pem** <br /> **chmod 400 backup-ec2-keypair.pem**
  5. go to the **automation/terraform** section of the project (_cd sbtphapp-project-devops/automation/terraform_)
  6. open the **variables.tfvars** file. This file hold the mysql credentials you can replace it with your own.
  7. Under **sbtphapp-project-devops/automation/terraform:** run the command: <br />
     1. terraform init <br />
     2. terraform plan -var-file=variables.tfvars  <br />
     3. terraform apply -var-file=variables.tfvars  -auto-approve <br />
  8. Wait for the terraform to finish creating the resources. When it's done, log in to your AWS account and check the resources created by the terraform.
  9. Terraform creates the following:<br />
      - Two Functional VPCs 1 for us-east-1 and 1 for us-east-2.
      - VPC peering between VPCs for replication connection of database instances
      - 3 Instances on each VPCs (1 frontend, 1, backend and 1 database instance) 
      
  10. For replication refer to the replication section of this link (**https://github.com/robudexIT/sbtphapp-project-devops/blob/lift-and-shift/README.md**)   
  11. After the project exercise, don't forget to run  **terraform destroy -var-file=variables.tfvars** to destroy all resources created by terraform. 
