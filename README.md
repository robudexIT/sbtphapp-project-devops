# sbtphapp-project-devops

In this branch, (lift-and-shift) replicate all company resources  aws cloud.

Company OnPrem                      AWS CLOUD
Branchs (Main and Annex) ---------- AWS REGION (us-east-1 and us-east-2)
company network infrustructure----- AWS VPC
company Servers ------------------- EC2 Instance


AWS Service Used on this project:
1. EC2 Instance
2. VPC 
3. AWS Lambda
4. AWS Cloudformation 
5. AWS IAM 
6. AWS CloudWatch Logs

Architecture:
![Alt text](sbtphapp_aws_lift_and_shift_architecture.png?raw=true "Title")

Notes:
  1. To avoid any human error, I decided to used AWS Cloudformation an AWS Infrastructure as Code Service to Automate the Creation of Infrastucture and all resources. Today's time Automation is very important. I tried to do some automation as much as possible on this project, from creating infrastructure , spinning up  instance, and install the neccessary services to reduce error from manual configuration setup.
  2. This project is tested on us-east-1 as main branch and us-east-2 as the annex branch.
  3. Use IAM user with administrator access when creating AWS Cloudformation stacks.

 Instructions:
 1. clone the source code project from github repository.
    git clone -b  lift-and-shift  https://github.com/robudexIT/sbtphapp-project-devops.git 
 2. Create EC2 keypair for ssh access on instance
    For us-east-1  keyname: ec2-main-keypair
    For us-east-2  keyname: ec2-annex-keypair
    Save the keypairs on your working directory and modify the permission 
    chmod 400 ec2-main-keypair
    chmod 400 ec2-annex-keypair
 3. create s3 bucket on main branch (us-east-1) make sure its unique in my case my bucket name is robudex-cf-templates
 4. change directory to sbtphapp-project-devops/automation/nestedstack
    cd sbtphapp-project-devops/automation/nestedstack
    open database.yaml look MYSQL* variables and put your choosen mysql and user and pass
        MYSQL_APP_USER=""
        MYSQL_APP_PWD=""
        MYSQL_REP_USER=""
        MYSQL_REP_PWD=""
 5. Upload these files on s3 your s3 bucket
    - database.yaml 
    - backend.yaml
    - frontend.yaml
    - vpc.yaml 
    - instancerole.json
    - lockdowndb.yaml
 6. open rootstack.yaml and replace the TemplateURL with your own template URL
 7. Creating the Cloudformation stack
    Select us-east-1 region and goto cloudformation and click the create stack button
    - Select Upload a template file  and choose the rootstack.yaml file
    - On stack details fillup the stackname and parameters just make sure choose the correct keypair.
    - Leave all default options and click NEXT
    - For Capabilities, check the two checkboxes and click Submit
 8. Select us-east-2 and follow the number 7 steps
 9. Wait for the stack to complete.
 10. When the two stacks are ready, on us-east-1 launch another another stack and choose the vpcpeering.yaml file fillup the stackname and parameters
 for PEERVPCID: <VPCID of us-east-2>
 for VPCID: <VPCID of us-east-1>
 - Leave all defalut options and click NEXT
 - For Capabilities, check the checkbox and click Submit
 - Wai for the stack to complete
 11. 

 