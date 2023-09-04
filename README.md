# sbtphapp-project-devops

In this branch, (lift-and-shift) replicates all company resources on  AWS Cloud.

1. Company OnPrem ---------------------- AWS CLOUD
2. Branches (Main and Annex) ----------  AWS REGION (us-east-1 and us-east-2)
3. Company Network Infrastructure -----  AWS VPC
4. Company Servers -------------------   EC2 Instance


**AWS Service Used on this Project:**
1. AWS EC2
2. AWS VPC 
3. AWS Lambda
4. AWS Cloudformation 
5. AWS IAM 
6. AWS CloudWatch Logs

**Current Architecture**
![Alt text](sbtphapp_current_arch.png?raw=true "Title")

**AWS Cloud Architecture:**:
![Alt text](sbtphapp_aws_lift_and_shift_architecture.png?raw=true "Title")

**Notes:**
  1. To avoid any human error, I decided to use AWS Cloudformation, AWS Infrastructure as Code Service to Automate the Creation of Infrastructure and all resources **(VPC,IAM,EC2,and Lambda)**. Today's time Automation is very important. I tried to do  Automation as much as possible on this project, from creating infrastructure, spinning up  instances, and installing the necessary services to reduce errors from manual configuration setup.
  2. This project is tested on **us-east-1** as the main branch and **us-east-2** as the annex branch.
  3. Use IAM user with administrator access when creating AWS Cloudformation stacks.

 **Instructions:**
 1. Clone the source code project from the GitHub repository.
    **git clone -b  lift-and-shift  https://github.com/robudexIT/sbtphapp-project-devops.git** 
 2. Create EC2 keypair for ssh access on instance.
    For us-east-1  keyname: **ec2-main-keypair** <br \>
    For us-east-2  keyname: **ec2-annex-keypair** </br \>
    Save the keypairs on your local machine and modify the permission <br \>
      **chmod 400 ec2-main-keypair.pem** <br \>
      **chmod 400 ec2-annex-keypair.pem** <br \>
 4. Create S3 bucket on main branch (**us-east-1**) make sure it is unique in my case my bucket name is **robudex-cf-templates**
 5. Change directory to sbtphapp-project-devops/cloudformation/automation/nestedstack
    **cd sbtphapp-project-devops/automation/cloudformation/nestedstack** <br \>
    open database.yaml look on MYSQL* variables and put your choosen mysql and user and pass <br \>
        MYSQL_APP_USER="" <br \>
        MYSQL_APP_PWD=""  <br \>
        MYSQL_REP_USER="" (replication user) <br \>
        MYSQL_REP_PWD=""  (replication password) <br \>
 6. Upload these files on s3 your s3 bucket. <br \>
    - database.yaml 
    - backend.yaml
    - frontend.yaml
    - vpc.yaml 
    - instancerole.json
    - lockdowndb.yaml
 7. Open **rootstack.yaml** and replace each TemplateURL Directive on each with your own template URL accordingly.
 8. Creating the Cloudformation stack. <br />
    Select **us-east-1** region and goto **AWS Cloudformation** and click the **create stack** button <br />
    - Select Upload a template file  and choose the **rootstack.yaml** file
    - On stack details fill up the stackname and parameters just make sure to choose the correct keypair.
    - For us-east-1 --> ec2-main-keypair.pem
    - For us-east-2 --> ec2-annex-keypair.pem
    - Leave all default options and click NEXT
    - For Capabilities, check the **two checkboxes** and click Submit
 9. Select **us-east-2** and follow the number 7 steps
 10. Wait for the stack to complete.<br />

 **us-east-1 stack:**
 ![Alt text](primarystack.png?raw=true "Title")
 
**us-east-2 stack:**
 ![Alt text](backupstack.png?raw=true "Title")
 11. When the two stacks are ready, on **us-east-1** launch  another stack and choose the **vpcpeering.yaml** file fillup the stackname and parameters.
 

 For PEERVPCID: <VPCID of us-east-2> <br />
 For VPCID: <VPCID of us-east-1>
 - Leave all default options and click NEXT
 - For Capabilities, check the checkbox and click Submit
 - Wait for the stack to complete

 **vpc-peering stack :**
  ![Alt text](vpcpeeringstack.png?raw=true "Title")

 For MYSQL REPLICATION steps
    Since the Database is no longer from the outside because it lockdown after  the necessary application was installed, we need to create a bastion host..for simplicity,  I  choose the backend instance as the bastion host.
   Select us-east-1 Region -> goto EC2 <br \>
   1. ssh to backend instance 
      - Once login, cd to /home/ubuntu/.ssh and create  **ec2-main-keypair.pem**
      - From your local workstation, open the  ec2-main-keypair.pem (the one that you saved earlier) copy and paste it to the backend instance  ec2-main-keypair.pem file.
      - Change the permission (chmod 400  ec2-main-keypair.pem)      - Get the database instance private ip and ssh to it 
        **ssh -i ec2-main-keypair.pem ubuntu@<datababse-private-ip>**
  2 . Select us-east-2 Region -> goto EC2 <br>
       Open a new terminal tab
       Repeat step 1 but replace keypair with ec2-annex-keypair.pem and use **ec2-annex-keypair.pem** instead.
  3. Once the ssh connection to the two database instances is established, On **us-east-2** Database Instance issue the following commands:<br \>
       - sudo su
       - mysql
       - show master status;
      The output must be similar to this:
        +--------------------+----------+--------------+------------------+ <br \>
        | File               | Position | Binlog_Do_DB | Binlog_Ignore_DB | <br \>
        +--------------------+----------+--------------+------------------+ <br \>
        | mariadb-bin.000001 |      330 | sbtphapp_db  |                  | <br \>
        +--------------------+----------+--------------+------------------+ <br \>
        Take note of this information. <br>
 4.  On us-east-1 Database Instance ssh session,  open /home/ubuntu/replicaiton.sh 
      - Fill in all variables
        file_from_server_remote_peer=< Filename from us-east-2 database instance> <br \>
        position_from_server_remote_peer=< Position from us-east-2 database instance> <br \>
        server_ip_remote_peer=<us-east-2 database instance private ip> <br \>
        replication_user_remote_peer=<replication user> <br \>
        your_password=<replicationpassowrd> <br \>
      
        
        example: <br \>
        server_ip_remote_peer="172.16.50.31" <br \>
        replication_user_remote_peer="sbtphapp_replication_user" <br \>
        your_password="sbtph@2018" <br \>
        file_from_server_remote_peer="mariadb-bin.000001" <br \>
        position_from_server_remote_peer=330 <br \>
      - run the script
        **/home/ubuntu/replicaiton.sh**
 5.  Repeat steps 3 and 4, but this time to replicate data from the **us-east-1** database instance to the
        **us-east-2** database instance,

 6 . On both Servers login mysql as root then type the command.<br \>
       **show slave status \G;**
       if it show on both server <br\>
            Slave_IO_Running:Yes
            Slave_SQL_Running: Yes
       Most probably, the replication setup was successful.
7. For testing, select the frontend instance of us-east-1 and us-east-2 stacks <br\>
       Get public ip address, open two browser tabs and paste it
       first tab http://<us-east-1-frontend-public-ip>/sbtph_app/login
       second tab http://<us-east-2-frontend-public-ip>/sbtph_app/login
8. Log in on apps.
      - extension: 6336
      - secret: 99999
9. On first tab, goto MANAGEMENT ->COLLECTIONS AGENTS. <br \>
       Click ADD AGENT <br \>
          - Name: devops_user01
          - Email_Address: devops_user01@gmail.com
          - Extension: 88888
          
         ![Alt text](appinfirsttab01.png?raw=true "Title") 

       As you can see, the user added in the number 8 
       ![Alt text](appinfirsttab02.png?raw=true "Title")

        On the second tab  goto MANAGEMENT ->COLLECTIONS AGENTS 
       If you can see the devops_user01, on the number 8 meaning replication was successful.
       ![Alt text](appinsecondtab.png.png?raw=true "Title")

 10. Try to delete devops_user01 on the second tab and you will see it also deleted in the first tab as well.

**Notes:** <br\>
  - After the exercise, please do not forget to delete all the cloudformation stack.

 Steps for Deleting Cloudformation Stacks:
 1. Delete the vpcpeering stack.
 2. Delete us-east-1 rootstack
 3. Delete us-east-2 rootstack

    
**This concludes the Instructions for this exercise. Thank You!** <br />    



       

 
