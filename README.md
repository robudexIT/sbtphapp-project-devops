# sbtphapp-project-devops

In this branch, (lift-and-shift) replicates all company resources on  aws cloud.

Company OnPrem                      AWS CLOUD
Branches (Main and Annex) ---------- AWS REGION (us-east-1 and us-east-2)
company network infrastructure ----- AWS VPC
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
  1. To avoid any human error, I decided to use AWS Cloudformation an AWS Infrastructure as Code Service to Automate the Creation of Infrastructure and all resources. Today's time Automation is very important. I tried to do some automation as much as possible on this project, from creating infrastructure, spinning up  instances, and installing the necessary services to reduce errors from manual configuration setup.
  2. This project is tested on us-east-1 as the main branch and us-east-2 as the annex branch.
  3. Use IAM user with administrator access when creating AWS Cloudformation stacks.

 Instructions:
 1. Clone the source code project from the GitHub repository.
    git clone -b  lift-and-shift  https://github.com/robudexIT/sbtphapp-project-devops.git 
 2. Create EC2 keypair for ssh access on instance
    For us-east-1  keyname: **ec2-main-keypair**
    For us-east-2  keyname: **ec2-annex-keypair**
    Save the keypairs on your working directory and modify the permission 
**    chmod 400 ec2-main-keypair.pem**
**    chmod 400 ec2-annex-keypair.pem**
 3. create s3 bucket on main branch (us-east-1) make sure its unique in my case my bucket name is **robudex-cf-templates**
 4. change directory to sbtphapp-project-devops/automation/nestedstack
    cd sbtphapp-project-devops/automation/cloudformation/nestedstack
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
 6. Open **rootstack.yaml ** and replace the TemplateURL with your own template URL
 7. Creating the Cloudformation stack
    Select us-east-1 region and goto cloudformation and click the create stack button
    - Select Upload a template file  and choose the rootstack.yaml file
    - On stack details fill up the stackname and parameters just make sure to choose the correct keypair.
    - Leave all default options and click NEXT
    - For Capabilities, check the ** two checkboxes** and click Submit
 8. Select us-east-2 and follow the number 7 steps
 9. Wait for the stack to complete.
 10. When the two stacks are ready, on us-east-1 launch another another stack and choose the vpcpeering.yaml file fillup the stackname and parameters

 us-east-1 stack:
 ![Alt text](primarystack.png?raw=true "Title")
 
 us-east-2 stack:
 ![Alt text](backupstack.png?raw=true "Title")



 for PEERVPCID: <VPCID of us-east-2>
 for VPCID: <VPCID of us-east-1>
 - Leave all default options and click NEXT
 - For Capabilities, check the checkbox and click Submit
 - Wait for the stack to complete

 vpc-peering stack :
  ![Alt text](vpcpeeringstack.png?raw=true "Title")

 
 11. For MYSQL REPLICATION steps
    Since the Database is no longer from the outside because it lockdown after  the necessary application was installed, we need to create a bastion host..for simplicity, 
    I  choose the backend instance as the bastion host.
   Select us-east-1 Region -> goto EC2 
   1. ssh to backend instance 
      - Once login, cd to /home/ubuntu/.ssh and create  **ec2-main-keypair.pem**
      - From your local workstation, open the  ec2-main-keypair.pem (the one that you saved earlier) copy and paste it to the backend instance  ec2-main-keypair.pem file.
      - Change the permission (chmod 400  ec2-main-keypair.pem)
      - Get the database instance private ip and ssh to it 
        ssh -i ec2-main-keypair.pem ubuntu@<datababse-private-ip>
    2. Select us-east-2 Region -> goto EC2
       Open a new terminal tab
       Repeat step 1 but replace keypair with ec2-annex-keypair.pem and use **ec2-annex-keypair.pem** instead.
    3. On us-east-2 Database Instance ssh session, issue commands
       - sudo su
       - mysql
       - show master status;
      The output must be similar to this:
        +--------------------+----------+--------------+------------------+
        | File               | Position | Binlog_Do_DB | Binlog_Ignore_DB |
        +--------------------+----------+--------------+------------------+
        | mariadb-bin.000001 |      330 | sbtphapp_db  |                  |
        +--------------------+----------+--------------+------------------+

    4.  On us-east-1 Database Instance ssh session,  open /home/ubuntu/replicaiton.sh 
      - Fill in all variables
        file_from_server_remote_peer=File
        position_from_server_remote_peer=Position
        
        example:
        server_ip_remote_peer="172.16.50.31"
        replication_user_remote_peer="sbtphapp_replication_user"
        your_password="sbtph@2018"
        file_from_server_remote_peer="mariadb-bin.000001"
        position_from_server_remote_peer=330
      - run the script
        /home/ubuntu/replicaiton.sh
    5.  Repeat 3 and 4 steps, but this time us-east-1 database instance is the source of bin file and position and to be copied on us-east-2  database instance

    6. On both Server login mysql as root then type the command
       show slave status \G;
       if it show on both server 
            Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
       Most probably, the replication setup was successful.
    7. For testing, select the frontend instance of us-east-1 and us-east-2
       Get public ip address, open two browser tabs and paste it
       first tab http://<us-east-1-frontend-public-ip>/sbtph_app/login
       second tab http://<us-east-2-frontend-public-ip>/sbtph_app/login
    8. login on apps
       extension: 6336
       secret: 99999
    9. On first tab, goto MANAGEMENT ->COLLECTIONS AGENTS
       Click ADD AGENT
          Name: devops_user01
          Email_Address: devops_user01@gmail.com
          Extension: 88888
         ![Alt text](appinfirsttab01.png?raw=true "Title") 

       As you can see, the user added in the number 8 
       ![Alt text](appinfirsttab02.png?raw=true "Title")

       on the second tab  goto MANAGEMENT ->COLLECTIONS AGENTS 
       If you can see the devops_user01, on the number 8 meaning replication was successful.
       ![Alt text](appinsecondtab.png.png?raw=true "Title")

    10. Try to delete devops_user01 on the second tab and you will see it also deleted in the first tab as well
    



       

 
