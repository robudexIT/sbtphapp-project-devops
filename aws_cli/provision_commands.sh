#!/bin/bash

#1. Creating VPC using  AWS Cloudformation in us-east-1 region
aws cloudformation create-stack --stack-name primary-vpc-stack \
--template-body file://automation/cloudformation/nestedstack/vpc.yaml \
--parameters ParameterKey=VpcName,ParameterValue=primaryVpc ParameterKey=SSHLocation,ParameterValue=0.0.0.0/0 --region us-east-1


aws cloudformation describe-stacks --stack-name primary-vpc-stack --region us-east-1
output: 
{
    "Stacks": [
        {
            "StackId": "arn:aws:cloudformation:us-east-1:427875724091:stack/primary-vpc-stack/becb9bb0-6e39-11ee-9d18-126ccbf01755",
            "StackName": "primary-vpc-stack",
            "Parameters": [
                {
                    "ParameterKey": "SSHLocation",
                    "ParameterValue": "0.0.0.0/0"
                },
                {
                    "ParameterKey": "VpcName",
                    "ParameterValue": "primaryVpc"
                }
            ],
            "CreationTime": "2023-10-19T04:41:18.911000+00:00",
            "RollbackConfiguration": {},
            "StackStatus": "CREATE_COMPLETE",
            "DisableRollback": false,
            "NotificationARNs": [],
            "Outputs": [
   {
        "OutputKey": "BackendSg",
        "OutputValue": "sg-07c4c616617bc4433"
    },
    {
        "OutputKey": "DBSubnetGroupRegion1",
        "OutputValue": "dbsubnetgroupregion1"
    },
    {
        "OutputKey": "DatabaseSg",
        "OutputValue": "sg-0abab7fe294f69774"
    },
    {
        "OutputKey": "VPCID",
        "OutputValue": "vpc-0e094cfef7bac00e5"
    },
    {
        "OutputKey": "FrontendSg",
        "OutputValue": "sg-0ecb8c0591e6337a2"
    },
    {
        "OutputKey": "DatabasePrivSub01",
        "OutputValue": "subnet-0e09161f167c1da1f"
    },
    {
        "OutputKey": "FrontendPubSub01",
        "OutputValue": "subnet-0b8a4a15d4d6a7d3b"
    },
    {
        "OutputKey": "FrontendPubSub02",
        "OutputValue": "subnet-0d8354deae04e52a6"
    },
    {
        "OutputKey": "BackendPubSub02",
        "OutputValue": "subnet-0d17089f59e9d31be"
    },
    {
        "OutputKey": "BackendPubSub01",
        "OutputValue": "subnet-0d9acd44a8d34a492"
    }
            ],
            "Tags": [],
            "EnableTerminationProtection": false,
            "DriftInformation": {
                "StackDriftStatus": "NOT_CHECKED"
            }
        }
    ]
}

aws cloudformation describe-stacks --stack-name primary-vpc-stack --query "Stacks[0].Outputs" --region us-east-1
output:
[
    {
        "OutputKey": "BackendSg",
        "OutputValue": "sg-07c4c616617bc4433"
    },
    {
        "OutputKey": "DBSubnetGroupRegion1",
        "OutputValue": "dbsubnetgroupregion1"
    },
    {
        "OutputKey": "DatabaseSg",
        "OutputValue": "sg-0abab7fe294f69774"
    },
    {
        "OutputKey": "VPCID",
        "OutputValue": "vpc-0e094cfef7bac00e5"
    },
    {
        "OutputKey": "FrontendSg",
        "OutputValue": "sg-0ecb8c0591e6337a2"
    },
    {
        "OutputKey": "DatabasePrivSub01",
        "OutputValue": "subnet-0e09161f167c1da1f"
    },
    {
        "OutputKey": "FrontendPubSub01",
        "OutputValue": "subnet-0b8a4a15d4d6a7d3b"
    },
    {
        "OutputKey": "FrontendPubSub02",
        "OutputValue": "subnet-0d8354deae04e52a6"
    },
    {
        "OutputKey": "BackendPubSub02",
        "OutputValue": "subnet-0d17089f59e9d31be"
    },
    {
        "OutputKey": "BackendPubSub01",
        "OutputValue": "subnet-0d9acd44a8d34a492"
    }
]


aws cloudformation describe-stacks --stack-name primary-vpc-stack --query "Stacks[0].StackStatus" --region us-east-1
ouput:
"CREATE_COMPLETE"




  #1. Creating VPC using  AWS Cloudformation in us-east-2 region
aws cloudformation create-stack --stack-name replica-vpc-stack \
--template-body file://automation/cloudformation/nestedstack/vpc.yaml \
--parameters ParameterKey=VpcName,ParameterValue=replicaVpc ParameterKey=SSHLocation,ParameterValue=0.0.0.0/0 --region us-east-2


# Describe cloudfromation stack 
aws cloudformation describe-stacks --stack-name replica-vpc-stack --region us-east-2

# Describe cloudfromation stack outputs
aws cloudformation describe-stacks --stack-name replica-vpc-stack --query "Stacks[0].Outputs" --region us-east-2
[
    {
        "OutputKey": "DatabasePrivSubReplica01",
        "OutputValue": "subnet-0f9fd260d61ce5878"
    },
    {
        "OutputKey": "DBSubnetGroupRegion2",
        "OutputValue": "dbsubnetgroupregion2"
    },
    {
        "OutputKey": "DatabaseSg",
        "OutputValue": "sg-0312ffc7c0deaae0d"
    },
    {
        "OutputKey": "VPCID",
        "OutputValue": "vpc-0d859a81d0dc27676"
    },
    {
        "OutputKey": "DatabasePrivSubReplica02",
        "OutputValue": "subnet-074fecfa0aa1f02d3"
    }
]

#List all cloudformation stack on specific region
aws cloudformation list-stacks --region us-east-1



#created RDS Instance
aws rds create-db-instance --db-instance-identifier primarydbinstance \
--db-instance-class db.t3.micro \
--engine mysql \
--engine-version 5.7.43 \
--master-username admin \
--master-user-password supersecretsecret2023 \
--vpc-security-group-ids sg-0abab7fe294f69774 \
--db-subnet-group-name dbsubnetgroupregion1 \
--db-name sbtphapp_db \
--backup-retention-period 1 \
--allocated-storage 20 \
--tags Key=Name,Value=primarydbinstance \
--region us-east-1 \
--no-publicly-accessible

#describe RDS Instance
aws rds describe-db-instances --db-instance-identifier primarydbinstance --region us-east-1
{
    "DBInstances": [
        {
            "DBInstanceIdentifier": "primarydbinstance",
            "DBInstanceClass": "db.t3.micro",
            "Engine": "mysql",
            "DBInstanceStatus": "available",
            "MasterUsername": "admin",
            "DBName": "sbtphapp_db",
            "Endpoint": {
                "Address": "primarydbinstance.ctgivagolcpv.us-east-1.rds.amazonaws.com",
                "Port": 3306,
                "HostedZoneId": "Z2R2ITUGPM61AM"
            },
            "AllocatedStorage": 20,
            "InstanceCreateTime": "2023-10-19T05:46:47.889000+00:00",
            "PreferredBackupWindow": "07:27-07:57",
            "BackupRetentionPeriod": 1,
            "DBSecurityGroups": [],
            "VpcSecurityGroups": [
                {
                    "VpcSecurityGroupId": "sg-0abab7fe294f69774",
                    "Status": "active"
                }
            ],
            "DBParameterGroups": [
                {
                    "DBParameterGroupName": "default.mysql5.7",
                    "ParameterApplyStatus": "in-sync"
                }
            ],
            "AvailabilityZone": "us-east-1f",
            "DBSubnetGroup": {
                "DBSubnetGroupName": "dbsubnetgroupregion1",
                "DBSubnetGroupDescription": "Subnet For RDS Instance",
                "VpcId": "vpc-0e094cfef7bac00e5",
                "SubnetGroupStatus": "Complete",
                "Subnets": [
                    {
                        "SubnetIdentifier": "subnet-0fefefa3a2fffb8c5",
                        "SubnetAvailabilityZone": {
                            "Name": "us-east-1f"
                        },
                        "SubnetOutpost": {},
                        "SubnetStatus": "Active"
                    },
                    {
                        "SubnetIdentifier": "subnet-0e09161f167c1da1f",
                        "SubnetAvailabilityZone": {
                            "Name": "us-east-1e"
                        },
                        "SubnetOutpost": {},
                        "SubnetStatus": "Active"
                    }
                ]
            },
            "PreferredMaintenanceWindow": "mon:04:45-mon:05:15",
            "PendingModifiedValues": {},
            "LatestRestorableTime": "2023-10-21T06:45:00+00:00",
            "MultiAZ": false,
            "EngineVersion": "5.7.43",
            "AutoMinorVersionUpgrade": true,
            "ReadReplicaDBInstanceIdentifiers": [],
            "LicenseModel": "general-public-license",
            "OptionGroupMemberships": [
                {
                    "OptionGroupName": "default:mysql-5-7",
                    "Status": "in-sync"
                }
            ],
            "PubliclyAccessible": false,
            "StorageType": "gp2",
            "DbInstancePort": 0,
            "StorageEncrypted": false,
            "DbiResourceId": "db-3PLTSTK57DQNML4B6PXYK6S4XM",
            "CACertificateIdentifier": "rds-ca-2019",
            "DomainMemberships": [],
            "CopyTagsToSnapshot": false,
            "MonitoringInterval": 0,
            "DBInstanceArn": "arn:aws:rds:us-east-1:427875724091:db:primarydbinstance",
            "IAMDatabaseAuthenticationEnabled": false,
            "PerformanceInsightsEnabled": false,
            "DeletionProtection": false,
            "AssociatedRoles": [],
            "TagList": [
                {
                    "Key": "Name",
                    "Value": "primarydbinstance"
                }
            ],
            "CustomerOwnedIpEnabled": false
        }
    ]
}

aws rds describe-db-instances --db-instance-identifier primarydbinstance --query "DBInstances[0].DBInstanceStatus" --region us-east-1
aws rds describe-db-instances --db-instance-identifier primarydbinstance --query "DBInstances[0].DBInstanceArn" --region us-east-1

#createtemporary instance
aws ec2 run-instances --image-id ami-0261755bbcb8c4a84 \
--instance-type t2.micro \
--key-name primary-ec2-keypair \
--subnet-id subnet-0d9acd44a8d34a492 \
--security-group-ids sg-07c4c616617bc4433 \
--user-data file://userdata/database.sh \
--tags Key=Name,Value=temporaryinstance \
--region us-east-1

#get instance id and takenote the "PublicIpAddress" and "InstanceId
 "InstanceId": "i-056461473385246d8"
aws ec2 describe-instances --filters "Name=tag:Name,Values=temporaryinstance" 

#get instance status check
aws ec2 describe-instance-status --instance-ids i-056461473385246d8


ssh -i primary-ec2-keypair.pem  ubuntu@54.91.34.254

dbhost: primarydbinstance.ctgivagolcpv.us-east-1.rds.amazonaws.com
dbuser: admin
dbpassword: supersecretsecret2023

#terminate the temporary instance
aws ec2 terminate-instances --instance-ids <instance-id>
aws ec2 describe-instances --instance-ids i-056461473385246d8

#request for certificate
aws acm request-certificate --domain-name *.robudexdevops.com --validation-method DNS
{
    "CertificateArn": "arn:aws:acm:us-east-1:427875724091:certificate/281e0766-5de3-4d4d-90bf-33b3144b4703"
}

#descibe certificate
aws acm describe-certificate --certificate-arn arn:aws:acm:us-east-1:427875724091:certificate/281e0766-5de3-4d4d-90bf-33b3144b4703
{
    "Certificate": {
        "CertificateArn": "arn:aws:acm:us-east-1:427875724091:certificate/281e0766-5de3-4d4d-90bf-33b3144b4703",
        "DomainName": "*.robudexdevops.com",
        "SubjectAlternativeNames": [
            "*.robudexdevops.com"
        ],
        "DomainValidationOptions": [
            {
                "DomainName": "*.robudexdevops.com",
                "ValidationDomain": "*.robudexdevops.com",
                "ValidationStatus": "PENDING_VALIDATION",
                "ResourceRecord": {
                    "Name": "_529534dcedf77a92f5d2fb66ed7ca9ba.robudexdevops.com.",
                    "Type": "CNAME",
                    "Value": "_f71f32f04f90546661002f91a803ec6c.tctzzymbbs.acm-validations.aws."
                },
                "ValidationMethod": "DNS"
            }
        ],
        "Subject": "CN=*.robudexdevops.com",
        "Issuer": "Amazon",
        "CreatedAt": "2023-10-19T15:04:14.051000+08:00",
        "Status": "PENDING_VALIDATION",
        "KeyAlgorithm": "RSA-2048",
        "SignatureAlgorithm": "SHA256WITHRSA",
        "InUseBy": [],
        "Type": "AMAZON_ISSUED",
        "KeyUsages": [],
        "ExtendedKeyUsages": [],
        "RenewalEligibility": "INELIGIBLE",
        "Options": {
            "CertificateTransparencyLoggingPreference": "ENABLED"
        }
    }

    {
    "Certificate": {
        "CertificateArn": "arn:aws:acm:us-east-1:427875724091:certificate/281e0766-5de3-4d4d-90bf-33b3144b4703",
        "DomainName": "*.robudexdevops.com",
        "SubjectAlternativeNames": [
            "*.robudexdevops.com"
        ],
        "DomainValidationOptions": [
            {
                "DomainName": "*.robudexdevops.com",
                "ValidationDomain": "*.robudexdevops.com",
                "ValidationStatus": "SUCCESS",
                "ResourceRecord": {
                    "Name": "_529534dcedf77a92f5d2fb66ed7ca9ba.robudexdevops.com.",
                    "Type": "CNAME",
                    "Value": "_f71f32f04f90546661002f91a803ec6c.tctzzymbbs.acm-validations.aws."
                },
                "ValidationMethod": "DNS"
            }
        ],
        "Serial": "03:c1:00:4c:46:0b:c0:db:a1:7a:f8:a1:f4:f4:43:c3",
        "Subject": "CN=*.robudexdevops.com",
        "Issuer": "Amazon",
        "CreatedAt": "2023-10-19T15:04:14.051000+08:00",
        "IssuedAt": "2023-10-19T15:08:44.059000+08:00",
        "Status": "ISSUED",
        "NotBefore": "2023-10-19T08:00:00+08:00",
        "NotAfter": "2024-11-17T07:59:59+08:00",
        "KeyAlgorithm": "RSA-2048",
        "SignatureAlgorithm": "SHA256WITHRSA",
        "InUseBy": [],
        "Type": "AMAZON_ISSUED",
        "KeyUsages": [
            {
                "Name": "DIGITAL_SIGNATURE"
            },
            {
                "Name": "KEY_ENCIPHERMENT"
            }
        ],
        "ExtendedKeyUsages": [
            {
                "Name": "TLS_WEB_SERVER_AUTHENTICATION",
                "OID": "1.3.6.1.5.5.7.3.1"
            },
            {
                "Name": "TLS_WEB_CLIENT_AUTHENTICATION",
                "OID": "1.3.6.1.5.5.7.3.2"
            }
        ],
        "RenewalEligibility": "INELIGIBLE",
        "Options": {
            "CertificateTransparencyLoggingPreference": "ENABLED"
        }
    }
}

}


#create backend_launch_template

aws ec2 create-launch-template --launch-template-name backend-launch-template \
--version-description "Initial version" \
--region us-east-1 \
--launch-template-data '{
  "UserData": "IyEvYmluL2Jhc2gKc3VkbyBhcHQgdXBkYXRlIC15CgpzdWRvIGFwdCBpbnN0YWxsIGFwYWNoZTIgIHBocCBwaHAtbXlzcWwgbXlzcWwtY2xpZW50IGdpdCAteQpzdWRvIGFwdCBpbnN0YWxsIGF3c2NsaSAteQpzdWRvIHN5c3RlbWN0bCBlbmFibGUgYXBhY2hlMgpzdWRvIHN5c3RlbWN0bCBzdGFydCBhcGFjaGUyCgpjZCAvdG1wICYmIGdpdCBjbG9uZSAtYiAgbGlmdC1hbmQtc2hpZnQgaHR0cHM6Ly9naXRodWIuY29tL3JvYnVkZXhJVC9zYnRwaGFwcC1wcm9qZWN0LWRldm9wcy5naXQKY2QgL3RtcC9zYnRwaGFwcC1wcm9qZWN0LWRldm9wcwoKREJfSE9TVF9JUD1wcmltYXJ5ZGJpbnN0YW5jZS5jdGdpdmFnb2xjcHYudXMtZWFzdC0xLnJkcy5hbWF6b25hd3MuY29tClNCVFBIQVBQX1VTRVI9YWRtaW4KU0JUUEhBUFBfUFdEPXN1cGVyc2VjcmV0c2VjcmV0MjAyMwpjcCAtciAvdG1wL3NidHBoYXBwLXByb2plY3QtZGV2b3BzL2JhY2tlbmQvc2J0cGhfYXBpLyAvdmFyL3d3dy9odG1sLwoKc3VkbyBzZWQgLWkgInMvWzAtOV1cK1woXC5bMC05XVwrXClcezNcfS8kREJfSE9TVF9JUC8iIC92YXIvd3d3L2h0bWwvc2J0cGhfYXBpL2NvbmZpZy9kYXRhYmFzZS5waHAKc3VkbyBzZWQgLWkgInMvU0JUUEhBUFBfVVNFUl9IRVJFLyRTQlRQSEFQUF9VU0VSLyIgL3Zhci93d3cvaHRtbC9zYnRwaF9hcGkvY29uZmlnL2RhdGFiYXNlLnBocApzdWRvIHNlZCAtaSAicy9TQlRQSEFQUF9QV0RfSEVSRS8kU0JUUEhBUFBfUFdELyIgL3Zhci93d3cvaHRtbC9zYnRwaF9hcGkvY29uZmlnL2RhdGFiYXNlLnBocAoKCiNjaGFuZ2Ugb3duZXJzaGlwIHRvIHVidW50dSB1c2VyIGFuZCBhcGFjaGUyIGdyb3VwCmNob3duIC1SIHVidW50dTp1YnVudHUgL3Zhci93d3cvaHRtbAoKc3VkbyBzeXN0ZW1jdGwgcmVzdGFydCBhcGFjaGUyCmNkIC4uIApzdWRvIHJtIC1yZiAvdG1wL3NidHBoYXBwLXByb2plY3QtZGV2b3Bz",
  "ImageId": "ami-0261755bbcb8c4a84",
  "KeyName": "primary-ec2-keypair",
  "SecurityGroupIds": ["sg-07c4c616617bc4433"],
  "InstanceType": "t2.micro"
}'

Output:
{
    "LaunchTemplate": {
        "LaunchTemplateId": "lt-017c3d0403c0e6975",
        "LaunchTemplateName": "backend-launch-template",
        "CreateTime": "2023-10-19T16:55:33+00:00",
        "CreatedBy": "arn:aws:iam::427875724091:user/terraform",
        "DefaultVersionNumber": 1,
        "LatestVersionNumber": 1
    }
}


#create backend target group
aws elbv2 create-target-group \
  --name backendTg \
  --protocol HTTP \
  --port 80 \
  --vpc-id vpc-0e094cfef7bac00e5 \
  --target-type instance \
  --tags Key=Name,Value=backendTg \
  --region us-east-1

  Output:
  {
    "TargetGroups": [
        {
            "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/backendTg/fa4b8b9030c538e7",
            "TargetGroupName": "backendTg",
            "Protocol": "HTTP",
            "Port": 80,
            "VpcId": "vpc-0e094cfef7bac00e5",
            "HealthCheckProtocol": "HTTP",
            "HealthCheckPort": "traffic-port",
            "HealthCheckEnabled": true,
            "HealthCheckIntervalSeconds": 30,
            "HealthCheckTimeoutSeconds": 5,
            "HealthyThresholdCount": 5,
            "UnhealthyThresholdCount": 2,
            "HealthCheckPath": "/",
            "Matcher": {
                "HttpCode": "200"
            },
            "TargetType": "instance",
            "ProtocolVersion": "HTTP1"
        }
    ]
}
#describe target-group base on name
aws elbv2 describe-target-groups --names backendTg
 
#create backend Appication Loadbalancer

aws elbv2 create-load-balancer \
  --name backendALB \
  --type application \
  --subnets subnet-0d9acd44a8d34a492 subnet-0d17089f59e9d31be \
  --security-groups sg-0dd8c938d3a717943 \
  --scheme internet-facing \
  --ip-address-type ipv4 \
  --region us-east-1

Output:
{
    "LoadBalancers": [
        {
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:427875724091:loadbalancer/app/backendALB/222eea016422b744",
            "DNSName": "backendALB-47426311.us-east-1.elb.amazonaws.com",
            "CanonicalHostedZoneId": "Z35SXDOTRQ7X7K",
            "CreatedTime": "2023-10-19T18:02:49.250000+00:00",
            "LoadBalancerName": "backendALB",
            "Scheme": "internet-facing",
            "VpcId": "vpc-0e094cfef7bac00e5",
            "State": {
                "Code": "provisioning"
            },
            "Type": "application",
            "AvailabilityZones": [
                {
                    "ZoneName": "us-east-1d",
                    "SubnetId": "subnet-0d17089f59e9d31be",
                    "LoadBalancerAddresses": []
                },
                {
                    "ZoneName": "us-east-1c",
                    "SubnetId": "subnet-0d9acd44a8d34a492",
                    "LoadBalancerAddresses": []
                }
            ],
            "SecurityGroups": [
                "sg-0dd8c938d3a717943"
            ],
            "IpAddressType": "ipv4"
        }
    ]
}

#describe backendALB
aws elbv2 describe-load-balancers --names backendALB

{
    "LoadBalancers": [
        {
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:427875724091:loadbalancer/app/backendALB/222eea016422b744",
            "DNSName": "backendALB-47426311.us-east-1.elb.amazonaws.com",
            "CanonicalHostedZoneId": "Z35SXDOTRQ7X7K",
            "CreatedTime": "2023-10-19T18:02:49.250000+00:00",
            "LoadBalancerName": "backendALB",
            "Scheme": "internet-facing",
            "VpcId": "vpc-0e094cfef7bac00e5",
            "State": {
                "Code": "active"
            },
            "Type": "application",
            "AvailabilityZones": [
                {
                    "ZoneName": "us-east-1d",
                    "SubnetId": "subnet-0d17089f59e9d31be",
                    "LoadBalancerAddresses": []
                },
                {
                    "ZoneName": "us-east-1c",
                    "SubnetId": "subnet-0d9acd44a8d34a492",
                    "LoadBalancerAddresses": []
                }
            ],
            "SecurityGroups": [
                "sg-0dd8c938d3a717943"
            ],
            "IpAddressType": "ipv4"
        }
    ]
}
aws elbv2 describe-load-balancers --names backendALB --query "LoadBalancers[0].State"
output
{
    "Code": "active"
}


#create backendALBSecureListner


aws elbv2 create-listener \
  --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:427875724091:loadbalancer/app/backendALB/222eea016422b744 \
  --protocol HTTPS \
  --port 443 \
  --ssl-policy ELBSecurityPolicy-TLS13-1-2-2021-06 \
  --certificates CertificateArn=arn:aws:acm:us-east-1:427875724091:certificate/281e0766-5de3-4d4d-90bf-33b3144b4703 \
  --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/backendTg/fa4b8b9030c538e7 \
  --tags Key=Name,Value=443Listener \
  --region us-east-1


  {
    "Listeners": [
        {
            "ListenerArn": "arn:aws:elasticloadbalancing:us-east-1:427875724091:listener/app/backendALB/222eea016422b744/146d8bcfb29e60ff",
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:427875724091:loadbalancer/app/backendALB/222eea016422b744",
            "Port": 443,
            "Protocol": "HTTPS",
            "Certificates": [
                {
                    "CertificateArn": "arn:aws:acm:us-east-1:427875724091:certificate/281e0766-5de3-4d4d-90bf-33b3144b4703"
                }
            ],
            "SslPolicy": "ELBSecurityPolicy-TLS13-1-2-2021-06",
            "DefaultActions": [
                {
                    "Type": "forward",
                    "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/backendTg/fa4b8b9030c538e7",
                    "ForwardConfig": {
                        "TargetGroups": [
                            {
                                "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/backendTg/fa4b8b9030c538e7",
                                "Weight": 1
                            }
                        ],
                        "TargetGroupStickinessConfig": {
                            "Enabled": false
                        }
                    }
                }
            ]
        }
    ]
}


#create backend ASG
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name backendASG \
  --launch-template LaunchTemplateName=backend-launch-template,Version=1 \
  --min-size 2 \
  --max-size 4 \
  --desired-capacity 2 \
  --availability-zones "us-east-1c" "us-east-1d" \
  --vpc-zone-identifier "subnet-0d9acd44a8d34a492, subnet-0d17089f59e9d31be" \
  --health-check-type ELB \
  --target-group-arns arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/backendTg/fa4b8b9030c538e7 \
  --tags Key=Name,Value=backendASG \
  --region us-east-1



#describe backendASG
 aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names  backendASG

 output
 {
    "AutoScalingGroups": [
        {
            "AutoScalingGroupName": "backendASG",
            "AutoScalingGroupARN": "arn:aws:autoscaling:us-east-1:427875724091:autoScalingGroup:8e4077f5-2295-4119-b152-779e343e9223:autoScalingGroupName/backendASG",
            "LaunchTemplate": {
                "LaunchTemplateId": "lt-017c3d0403c0e6975",
                "LaunchTemplateName": "backend-launch-template",
                "Version": "1"
            },
            "MinSize": 2,
            "MaxSize": 4,
            "DesiredCapacity": 2,
            "DefaultCooldown": 300,
            "AvailabilityZones": [
                "us-east-1c",
                "us-east-1d"
            ],
            "LoadBalancerNames": [],
            "TargetGroupARNs": [
                "arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/backendTg/fa4b8b9030c538e7"
            ],
            "HealthCheckType": "ELB",
            "HealthCheckGracePeriod": 0,
            "Instances": [
                {
                    "InstanceId": "i-07bd90f5da6b100b4",
                    "InstanceType": "t2.micro",
                    "AvailabilityZone": "us-east-1d",
                    "LifecycleState": "Terminating",
                    "HealthStatus": "Unhealthy",
                    "LaunchTemplate": {
                        "LaunchTemplateId": "lt-017c3d0403c0e6975",
                        "LaunchTemplateName": "backend-launch-template",
                        "Version": "1"
                    },
                    "ProtectedFromScaleIn": false
                },
                {
                    "InstanceId": "i-09d9712f272e752ef",
                    "InstanceType": "t2.micro",
                    "AvailabilityZone": "us-east-1d",
                    "LifecycleState": "Pending",
                    "HealthStatus": "Healthy",
                    "LaunchTemplate": {
                        "LaunchTemplateId": "lt-017c3d0403c0e6975",
                        "LaunchTemplateName": "backend-launch-template",
                        "Version": "1"
                    },
                    "ProtectedFromScaleIn": false
                },
                {
                    "InstanceId": "i-0f8886995d5433de6",
                    "InstanceType": "t2.micro",
                    "AvailabilityZone": "us-east-1c",
                    "LifecycleState": "InService",
                    "HealthStatus": "Healthy",
                    "LaunchTemplate": {
                        "LaunchTemplateId": "lt-017c3d0403c0e6975",
                        "LaunchTemplateName": "backend-launch-template",
                        "Version": "1"
                    },
                    "ProtectedFromScaleIn": false
                }
            ],
            "CreatedTime": "2023-10-19T18:57:49.266000+00:00",
            "SuspendedProcesses": [],
            "VPCZoneIdentifier": "subnet-0d17089f59e9d31be,subnet-0d9acd44a8d34a492",
            "EnabledMetrics": [],
            "Tags": [
                {
                    "ResourceId": "backendASG",
                    "ResourceType": "auto-scaling-group",
                    "Key": "Name",
                    "Value": "backendASG",
                    "PropagateAtLaunch": true
                }
            ],
            "TerminationPolicies": [
                "Default"
            ],
            "NewInstancesProtectedFromScaleIn": false,
            "ServiceLinkedRoleARN": "arn:aws:iam::427875724091:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        }
    ]
}

aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names  backendASG --query "AutoScalingGroups[0].Instances"

output:
[
    {
        "InstanceId": "i-07bd90f5da6b100b4",
        "InstanceType": "t2.micro",
        "AvailabilityZone": "us-east-1d",
        "LifecycleState": "Terminating",
        "HealthStatus": "Unhealthy",
        "LaunchTemplate": {
            "LaunchTemplateId": "lt-017c3d0403c0e6975",
            "LaunchTemplateName": "backend-launch-template",
            "Version": "1"
        },
        "ProtectedFromScaleIn": false
    },
    {
        "InstanceId": "i-09d9712f272e752ef",
        "InstanceType": "t2.micro",
        "AvailabilityZone": "us-east-1d",
        "LifecycleState": "InService",
        "HealthStatus": "Healthy",
        "LaunchTemplate": {
            "LaunchTemplateId": "lt-017c3d0403c0e6975",
            "LaunchTemplateName": "backend-launch-template",
            "Version": "1"
        },
        "ProtectedFromScaleIn": false
    },
    {
        "InstanceId": "i-0f8886995d5433de6",
        "InstanceType": "t2.micro",
        "AvailabilityZone": "us-east-1c",
        "LifecycleState": "InService",
        "HealthStatus": "Healthy",
        "LaunchTemplate": {
            "LaunchTemplateId": "lt-017c3d0403c0e6975",
            "LaunchTemplateName": "backend-launch-template",
            "Version": "1"
        },
        "ProtectedFromScaleIn": false
    }
]
#describe registerd targets within the target group backendTg
aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/backendTg/fa4b8b9030c538e7

Output:
{
    "TargetHealthDescriptions": [
        {
            "Target": {
                "Id": "i-09d9712f272e752ef",
                "Port": 80
            },
            "HealthCheckPort": "80",
            "TargetHealth": {
                "State": "healthy"
            }
        },
        {
            "Target": {
                "Id": "i-0f8886995d5433de6",
                "Port": 80
            },
            "HealthCheckPort": "80",
            "TargetHealth": {
                "State": "healthy"
            }
        }
    ]
}

#encode frontend.sh into base64 encoding
base64 -w 0 < userdata/frontend.sh  

#create backend_launch_template
aws ec2 create-launch-template --launch-template-name frontend-launch-template \
--version-description "Initial version" \
--region us-east-1 \
--launch-template-data '{
  "UserData": "IyEvYmluL2Jhc2gKc3VkbyBhcHQgdXBkYXRlIC15CgpzdWRvIGFwdCBpbnN0YWxsIGFwYWNoZTIgIC15CnN1ZG8gYXB0IGluc3RhbGwgYXdzY2xpIC15CnN1ZG8gc3lzdGVtY3RsIGVuYWJsZSBhcGFjaGUyCnN5c3RlbWN0bCBzdGFydCBhcGFjaGUyCgoKI2dldCB0aGUgcHVibGljIGlwIGFkZHJlc3Mgb2YgdGhlIEluc3RhbmNlIE5hbWU9QmFja2VuZApBV1NfQVBJX0lQPSJiYWNrZW5kQUxCLTQ3NDI2MzExLnVzLWVhc3QtMS5lbGIuYW1hem9uYXdzLmNvbSIKY2QgL3RtcCAgJiYgZ2l0IGNsb25lIC1iICBsaWZ0LWFuZC1zaGlmdCAgaHR0cHM6Ly9naXRodWIuY29tL3JvYnVkZXhJVC9zYnRwaGFwcC1wcm9qZWN0LWRldm9wcy5naXQKCgpjcCAtciAvdG1wL3NidHBoYXBwLXByb2plY3QtZGV2b3BzL2Zyb250ZW5kL3NidHBoX2FwcC8gL3Zhci93d3cvaHRtbC8KCiNSZXBsYWNlIHRoZSBBUEkgZW5kcG9pbnQgdG8gQmFja2VuZEFMQgpmaW5kIC92YXIvd3d3L2h0bWwvc2J0cGhfYXBwL2pzL2FwcCogLXR5cGUgZiAtZXhlYyBzZWQgLUUgLWkgInMvXGIoWzAtOV17MSwzfVwuKXszfVswLTldezEsM31cYi8kQVdTX0FQSV9JUC9nIiB7fSArCgpzdWRvIGNob3duIC1SIHVidW50dTp1YnVudHUgL3Zhci93d3cvaHRtbAogCiN0aGlzIGNvZGUgd2lsbCBkZWFsIG9uIFNQQSBhcHBsaWNhdGlvbiAKbXYgL2V0Yy9hcGFjaGUyL3NpdGVzLWF2YWlsYWJsZS8wMDAtZGVmYXVsdC5jb25mIC9ldGMvYXBhY2hlMi9zaXRlcy1hdmFpbGFibGUvMDAwLWRlZmF1bHQuY29uZi1iYWNrdXAKY3AgZnJvbnRlbmQvY29uZi9hcGFjaGUyLzAwMC1kZWZhdWx0LmNvbmYgL2V0Yy9hcGFjaGUyL3NpdGVzLWF2YWlsYWJsZS8Kc3VkbyBhMmVubW9kIHJld3JpdGUKc3VkbyBzeXN0ZW1jdGwgcmVzdGFydCBhcGFjaGUyCgpzdWRvIHN5c3RlbWN0bCBlbmFibGUgdXBkYXRlX2FwaV9pcC5zZXJ2aWNlCnN1ZG8gc3lzdGVtY3RsIHN0YXJ0IHVwZGF0ZV9hcGlfaXAuc2VydmljZQoKY2QgLi4Kc3VkbyBybSAtcmYgIC90bXAvc2J0cGhhcHAtcHJvamVjdC1kZXZvcHMKCgo=",
  "ImageId": "ami-0261755bbcb8c4a84",
  "KeyName": "primary-ec2-keypair",
  "SecurityGroupIds": ["sg-0ecb8c0591e6337a2"],
  "InstanceType": "t2.micro"
}'


#create frontend target group
aws elbv2 create-target-group \
  --name frontendTg \
  --protocol HTTP \
  --port 80 \
  --vpc-id vpc-0e094cfef7bac00e5 \
  --target-type instance \
  --tags Key=Name,Value=frontendTg \
  --region us-east-1

  #create frontend Appication Loadbalancer

aws elbv2 create-load-balancer \
  --name frontendALB \
  --type application \
  --subnets subnet-0b8a4a15d4d6a7d3b subnet-0d8354deae04e52a6 \
  --security-groups sg-08e3d08e2ba23bd7e \
  --scheme internet-facing \
  --ip-address-type ipv4 \
  --region us-east-1

#create ALB secured listener for frontendALB
aws elbv2 create-listener \
  --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:427875724091:loadbalancer/app/frontendALB/963647722ef9c155 \
  --protocol HTTPS \
  --port 443 \
  --ssl-policy ELBSecurityPolicy-TLS13-1-2-2021-06 \
  --certificates CertificateArn=arn:aws:acm:us-east-1:427875724091:certificate/281e0766-5de3-4d4d-90bf-33b3144b4703 \
  --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/frontendTg/a412b66a0d7f9590 \
  --tags Key=Name,Value=443Listener \
  --region us-east-1


  #create fronted ASG
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name frontendASG \
  --launch-template LaunchTemplateName=frontend-launch-template,Version=1 \
  --min-size 2 \
  --max-size 4 \
  --desired-capacity 2 \
  --availability-zones "us-east-1a" "us-east-1b" \
  --vpc-zone-identifier "subnet-0b8a4a15d4d6a7d3b, subnet-0d8354deae04e52a6" \
  --health-check-type ELB \
  --target-group-arns arn:aws:elasticloadbalancing:us-east-1:427875724091:targetgroup/frontendTg/a412b66a0d7f9590 \
  --tags Key=Name,Value=frontendASG \
  --region us-east-1



#DELETE RESOUCE
1.delete frontend and backend ALB
  aws elbv2  delete-load-balancer --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:427875724091:loadbalancer/app/frontendALB/963647722ef9c155
  aws elbv2  describe-load-balancers
  {
    "LoadBalancers": []
  }
2.delete fronted and backend Target group
  aws elbv2 delete-target-group --target-group-arn
  aws elbv2 describe-target-groups
  {
    "TargetGroups": []
  }
3.delete ASG
  aws autoscaling delete-auto-scaling-group --force-delete  --auto-scaling-group-name backendASG 
  aws autoscaling describe-auto-scaling-groups
  {
    "AutoScalingGroups": []
  }
4.delete launch template 
  aws ec2 delete-launch-template --launch-template-id <template-id> --region us-east-1
  aws ec2 describe-launch-templates -region us-east-1
  {
     "LaunchTemplates": []
  }
 5.delete rds instances 
   aws rds delete-db-instance --db-instance-identifier primarydbinstance  --skip-final-snapshot --region us-east-1
   aws rds delete-db-instance --db-instance-identifier readreplicadbinstance  --skip-final-snapshot --region us-east-2
   aws rds descibe-db-instances --region <YOUR REGION>
   {
    "DBInstances": []
   }
 6. delete vpc cloudformation templates 
    - list Stacks 
      aws cloudformation list-stacks --region <YOUR REGION> 
      aws cloudformation delete-stack --stack-name primary-vpc-stack
      aws cloudformation delete-stack --stack-name replica-vpc-stack

      
      



#create rds readreplica
aws rds create-db-instance-read-replica \
--db-instance-identifier readreplicadbinstance \
--source-db-instance-identifier arn:aws:rds:us-east-1:427875724091:db:primarydbinstance \
--db-instance-class db.t3.micro \
--no-publicly-accessible \
--db-subnet-group-name dbsubnetgroupregion2 \
--vpc-security-group-ids sg-0312ffc7c0deaae0d \
--source-region us-east-1 \
--tags Key=Name,Value=readreplicadbinstance \
--region us-east-2 

output:
{
    "DBInstance": {
        "DBInstanceIdentifier": "readreplicadbinstance",
        "DBInstanceClass": "db.t3.micro",
        "Engine": "mysql",
        "DBInstanceStatus": "creating",
        "MasterUsername": "admin",
        "DBName": "sbtphapp_db",
        "AllocatedStorage": 20,
        "PreferredBackupWindow": "07:27-07:57",
        "BackupRetentionPeriod": 0,
        "DBSecurityGroups": [],
        "VpcSecurityGroups": [
            {
                "VpcSecurityGroupId": "sg-0312ffc7c0deaae0d",
                "Status": "active"
            }
        ],
        "DBParameterGroups": [
            {
                "DBParameterGroupName": "default.mysql5.7",
                "ParameterApplyStatus": "in-sync"
            }
        ],
        "DBSubnetGroup": {
            "DBSubnetGroupName": "dbsubnetgroupregion2",
            "DBSubnetGroupDescription": "Subnet For RDS Instance",
            "VpcId": "vpc-0d859a81d0dc27676",
            "SubnetGroupStatus": "Complete",
            "Subnets": [
                {
                    "SubnetIdentifier": "subnet-0f9fd260d61ce5878",
                    "SubnetAvailabilityZone": {
                        "Name": "us-east-2a"
                    },
                    "SubnetOutpost": {},
                    "SubnetStatus": "Active"
                },
                {
                    "SubnetIdentifier": "subnet-074fecfa0aa1f02d3",
                    "SubnetAvailabilityZone": {
                        "Name": "us-east-2b"
                    },
                    "SubnetOutpost": {},
                    "SubnetStatus": "Active"
                }
            ]
        },
        "PreferredMaintenanceWindow": "mon:04:45-mon:05:15",
        "PendingModifiedValues": {},
        "MultiAZ": false,
        "EngineVersion": "5.7.43",
        "AutoMinorVersionUpgrade": true,
        "ReadReplicaSourceDBInstanceIdentifier": "arn:aws:rds:us-east-1:427875724091:db:primarydbinstance",
        "ReadReplicaDBInstanceIdentifiers": [],
        "LicenseModel": "general-public-license",
        "OptionGroupMemberships": [
            {
                "OptionGroupName": "default:mysql-5-7",
                "Status": "pending-apply"
            }
        ],
        "PubliclyAccessible": false,
        "StorageType": "gp2",
        "DbInstancePort": 0,
        "StorageEncrypted": false,
        "DbiResourceId": "db-ZBUCMYHCD7K4WEDLVEGJAGMSJU",
        "CACertificateIdentifier": "rds-ca-2019",
        "DomainMemberships": [],
        "CopyTagsToSnapshot": false,
        "MonitoringInterval": 0,
        "DBInstanceArn": "arn:aws:rds:us-east-2:427875724091:db:readreplicadbinstance",
        "IAMDatabaseAuthenticationEnabled": false,
        "PerformanceInsightsEnabled": false,
        "DeletionProtection": false,
        "AssociatedRoles": [],
        "TagList": [
            {
                "Key": "Name",
                "Value": "readreplicadbinstance"
            }
        ],
        "CustomerOwnedIpEnabled": false
    }
}

aws rds describe-db-instances --db-instance-identifier readreplicadbinstance --query "DBInstances[0].DBInstanceStatus" --region us-east-2
aws rds describe-db-instances --db-instance-identifier readreplicadbinstance --query "DBInstances[0].DBInstanceArn" --region us-east-2


aws rds describe-db-instances --db-instance-identifier readreplicadbinstance --query "DBInstances[0].ReadReplicaSourceDBInstanceIdentifier" --region us-east-2
output:
"arn:aws:rds:us-east-1:427875724091:db:primarydbinstance" = replica

aws rds describe-db-instances --db-instance-identifier primarydbinstance --query "DBInstances[0].ReadReplicaSourceDBInstanceIdentifier" --region us-east-1
null = primary
