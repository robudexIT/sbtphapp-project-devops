
# TERRAFORM Setup for SBTPHAPP-DEVOPS-PROJECT

This README provides step-by-step instructions for setting up and configuring the SBTPHAPP-DEVOPS-PROJECT using TERRAFORM. 

## Prerequisites

Before you begin, ensure that you have the following:

- **Git Repository:** Clone this GitHub repository by running the following command:

    ```shell
    git clone -b lift-and-shift-high-availability https://github.com/robudexIT/sbtphapp-project-devops.git
    ```

    This cloned repository will serve as your working project directory.

- **Key Pairs:** Create two key pairs, one for `us-east-1` and one for `us-east-2`, and save them to your working project directory.

- You should have registered domain name.

- Create AWS Certificate in Advance. For tutorial how to create Certificate, here's the link https://github.com/robudexIT/sbtphapp-project-devops/tree/lift-and-shift-high-availability/automation/cloudformation  And go to 6 up 9 of the tutorial

Please ensure that you have met these prerequisites before proceeding with the setup.

## Architecture Overview

Include a brief description and a diagram of the architecture built using the Terraform.

![Architecture Diagram](../../screenshots/sbtphapp_aws_lift_and_shift_high_availability.png)

**Instructions:** <br />
  1. First thing first, you  need to install the Terraform software on your local machine. Here's the link on how to install it based on the Operating System that you are using **https://developer.hashicorp.com/terraform/downloads?product_intent=terraform**

  2. cd to (_cd sbtphapp-project-devops/automation/terraform_)
  3. open the **variables.tfvars** and supply all empty variables in file and save it. ( see the sample below). <br />
      
        ```shell
            mysql_app_user="admin"
            mysql_app_pwd="supersecret"
            db_instance_class = "db.t3.micro"
            primary_db_identifier = "primarydbinstance"
            replica_db_identifier = "replicadbinstance"
            backend_subdomain = "mybackend"
            frontend_subdomain = "myfrontend"
            registered_domain = "robudexdevops.com"
            certificate_arn = "arn:aws:acm:us-east-1:11111111:certificate/281e0766-5de3-4d4d-90bf-33b3144b4703"
        ```

  4. Under **sbtphapp-project-devops/automation/terraform:** run the command: <br />
     1. terraform init <br />
     2. terraform plan -var-file=variables.tfvars  <br />
     3. terraform apply -var-file=variables.tfvars  -auto-approve <br />
  5. Wait for the terraform to finish creating the resources. When it's done, Look for the outputs. Add these Outputs Informations to your GoDaddy DNS Records.  <br />

       ```shell
          Type: CNAME
          Name: <backend_subdomain-VALUE> 
          Value: <sbtphapp_backend_loadbalancer_dns_name-VALUE>

          Type: CNAME
          Name: <frontend_subdomain-VALUE> 
          Value: <sbtphapp_frontend_loadbalancer_dns_name-VALUE>
        ```
  
  6. If you are using GoDaddy, it should be like the screenshot below:<br />

   ![GooDaddy Adding Records](../../screenshots/frontend_backend_dns_records.png)


  7. For Testing The App, please refer to step 13 of https://github.com/robudexIT/sbtphapp-project-devops/tree/lift-and-shift-high-availability/automation/cloudformation <br />

      

  8. After the project exercise, don't forget to run  **terraform destroy -var-file=variables.tfvars** to destroy all resources created by terraform. 
