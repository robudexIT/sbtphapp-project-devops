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

 us-east-1 stack:
 ![Alt text](primarystack.png?raw=true "Title")
 
 us-east-2 stack:
 ![Alt text](backupstack.png?raw=true "Title")



 for PEERVPCID: <VPCID of us-east-2>
 for VPCID: <VPCID of us-east-1>
 - Leave all defalut options and click NEXT
 - For Capabilities, check the checkbox and click Submit
 - Wait for the stack to complete

 vpc-peering stack :
  ![Alt text](vpcpeeringstack.png?raw=true "Title")

 
 11. For MYSQL REPLICATION steps
    Since Database has no longer from the outside because its lockdown after  the neccessary application was installed, we need to create bastion host..for simplicity, 
    I  choose the backend instance as the bastion host.
   Select us-east-1 Region -> goto EC2 
   1. ssh to backend instance 
      - once login, cd to /home/ubuntu/.ssh and create  ec2-main-keypair.pem
      - from your local workstation, open the  ec2-main-keypair.pem (the one that you save earlier) copy and pasted to backend instance  ec2-main-keypair.pem file.
      - change the permission (chmod 400  ec2-main-keypair.pem)
      - get the database instance private ip and ssh to it 
        ssh -i ec2-main-keypair.pem ubuntu@<datababse-private-ip>
    2. Select us-east-2 Region -> goto EC2
       open new terminal tab
       Repeat step 1 but replace keypair with ec2-annex-keypair.pem and use ec2-annex-keypair.pem instead.
    3. On us-east-2 Database Instance ssh session, issue commands
       - sudo su
       - mysql
       - show master status;
      The oupt must similar to this:
        +--------------------+----------+--------------+------------------+
        | File               | Position | Binlog_Do_DB | Binlog_Ignore_DB |
        +--------------------+----------+--------------+------------------+
        | mariadb-bin.000001 |      330 | sbtphapp_db  |                  |
        +--------------------+----------+--------------+------------------+

    4.  On us-east-1 Database Instance ssh session,  open /home/ubuntu/replicaiton.sh 
      - Fillin all variables
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

    6. On both Server login mysql as root then type command
       show slave status \G;
       if it show on both server 
            Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
       Most probably , the replication setup was successful.
    7. For testing, select frontend instance of us-east-1 and us-east-2
       get public ip address, open two browser tabs and paste it
       first tab http://<us-east-1-frontend-public-ip>/sbtph_app/login
       secodn tab http://<us-east-2-frontend-public-ip>/sbtph_app/login
    8. login on apps
       extension: 6336
       secret: 99999
    9. on first tab, goto MANAGEMENT ->COLLECTIONS AGENTS
       Click ADD AGENT
          Name: devops_user01
          Email_Address: devops_user01@gmail.com
          Extension: 88888
         ![Alt text](app_in_first_tab01.png?raw=true "Title") 

       As you can see, user add on the number 8 
       ![Alt text](app_in_first_tab02.png?raw=true "Title")

       on second tab  goto MANAGEMENT ->COLLECTIONS AGENTS 
       if you can see the devops_user01, on the number 8 meaning replication was successful.
       ![Alt text](app_in_second_tab.png.png?raw=true "Title")

    10. try to delete devops_user01 on the second tab and you will see it also deleted in first tab as well
    



       

 