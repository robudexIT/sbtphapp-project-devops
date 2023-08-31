#!/home/robudex/anaconda3/bin/python3

import boto3
from botocore.config import Config 
import time

client = boto3.client('ec2')
# peer_region_client = boto3.clien('ec2', config=PEER_REGION_CONFIG)

describe_vpc_peering_connections= client.describe_vpc_peering_connections(
                        Filters=[
                            {
                                'Name': 'accepter-vpc-info.vpc-id',
                                'Values': [
                                    "vpc-06ca52a45b571d43e",
                                ]
                            },
                            {
                                'Name': 'requester-vpc-info.vpc-id',
                                'Values': [
                                    "vpc-086cc458f431c6ed8",
                                ]
                            },
                            {
                                'Name': 'status-code',
                                'Values': ['active']
                            }
                        ],

                        )
vpc02_cidrblock = describe_vpc_peering_connections['VpcPeeringConnections'][0]['AccepterVpcInfo']['CidrBlock'] 
vpc01_cidrblock = describe_vpc_peering_connections['VpcPeeringConnections'][0]['RequesterVpcInfo']['CidrBlock']
VpcPeeringConnectionId = describe_vpc_peering_connections['VpcPeeringConnections'][0]['VpcPeeringConnectionId']
              
revoke_security_group_ingress_for_Region1_DatabaseSg  = client.revoke_security_group_ingress(
                    GroupId=  "sg-0b34d558e8c98492b",
                    CidrIp = "172.16.0.0/16",
                    FromPort = -1 ,
                    ToPort = -1 ,
                    IpProtocol = "-1",
                    # TagSpecifications = [
                            
                    #     {
                    #         'ResourceType': 'security-group-rule',
                    #         'Tags': [
                    #             {
                    #                 'Key': 'CidrIp',
                    #                 'Value': "172.16.0.0/16" 
                    #             },
                    #             {
                    #                 'Key': 'GroupId',
                    #                 'Value':  "sg-0b34d558e8c98492b" 
                    #             }, 
                    #             {
                    #                 'Key': 'FromPort',
                    #                 'Value': "-1"
                    #             },
                    #             {
                    #                 'Key': 'ToPort',
                    #                 'Value': "-1" 
                    #             },
                    #             {
                    #                 'Key': 'IpProtocol',
                    #                 'Value': '-1'
                    #             }
                    #         ]
                    #     }
                    #     ]
                    
            )
if revoke_security_group_ingress_for_Region1_DatabaseSg['Return']:
    print("Ingress asscess for {} to {}  has been revoked".format("172.16.0.0/16", "sg-0b34d558e8c98492b"))

# describe_vpc_peering_connections= client.describe_vpc_peering_connections(
#     Filters=[
#         {
#             'Name': 'accepter-vpc-info.vpc-id',
#             'Values': [
#                 'vpc-06ca52a45b571d43e',
#             ]
#         },
#         {
#             'Name': 'requester-vpc-info.vpc-id',
#             'Values': [
#                 'vpc-086cc458f431c6ed8',
#             ]
#         },
#     ],

# )

# if describe_vpc_peering_connections['VpcPeeringConnections'] == 0 :

#     create_vpc_peering_connection = client.create_vpc_peering_connection(
#                 # DryRun = True,
#                 PeerVpcId = 'vpc-06ca52a45b571d43e',
#                 VpcId = 'vpc-086cc458f431c6ed8', 
#                 PeerRegion = 'us-east-2'
            
#                 ) 
#     print(create_vpc_peering_connection['VpcPeeringConnection']['VpcPeeringConnectionId'])
# else:
#     print('VPC peering was already created..')
#     vpc02_cidrblock = describe_vpc_peering_connections['VpcPeeringConnections'][0]['AccepterVpcInfo']['CidrBlock'] 
#     vpc01_cidrblock = describe_vpc_peering_connections['VpcPeeringConnections'][0]['RequesterVpcInfo']['CidrBlock']
#     VpcPeeringConnectionId = describe_vpc_peering_connections['VpcPeeringConnections'][0]['VpcPeeringConnectionId']
#     print(vpc02_cidrblock)
#     print(vpc01_cidrblock)
#     print(VpcPeeringConnectionId)
# describe_route_tables = client.describe_route_tables(
#     Filters=[
#         {
#             'Name': 'route.destination-cidr-block',
#             'Values': [
#                 '10.10.0.0/16',
#             ]
#         },
#         {
#             'Name': 'route.vpc-peering-connection-id',
#             'Values': ['pcx-0d223e51d131032e3']
#         }, 
#         {
#             'Name': 'route-table-id',
#             'Values': ['rtb-01759a4ff0b4032c1']
#         }
#     ],
   
# )
# if len(describe_route_tables['RouteTables']) == 0 :

#     create_route_vpc_region1 = client.create_route(
#                         DestinationCidrBlock = "10.10.0.0/16",
#                         RouteTableId = 'rtb-01759a4ff0b4032c1' ,
#                         VpcPeeringConnectionId = 'pcx-0d223e51d131032e3'

#     )
# else:
#     print('Route is already exist')

# check_security_group_rule = client.describe_security_group_rules(
#     Filters=[
#         {
#             'Name': 'group-id',
#             'Values': [
#                 'sg-0b34d558e8c98492b',
#             ]
#         },
#         {
#             'Name': 'tag:CidrIp',
#             'Values': ['10.10.0.0/16']
#         },
#         {
#             'Name': 'tag:IpProtocol',
#             'Values': ['-1']
#         }, 
#         {
#             'Name': 'tag:FromPort',
#             'Values': ['-1']
#         },
#         {
#             'Name': 'tag:ToPort',
#             'Values': ['-1']
#         }
        
#     ]
   
# )
# if len(check_security_group_rule['SecurityGroupRules']) == 0 :
#     authorize_security_group_ingress_for_Region1_DatabaseSg  = client.authorize_security_group_ingress(
#                         GroupId= 'sg-0b34d558e8c98492b' ,
#                         CidrIp = '10.10.0.0/16',
#                         FromPort = -1 ,
#                         ToPort = -1 ,
#                         IpProtocol = "-1",
#                         TagSpecifications = [
                            
#                         {
#                             'ResourceType': 'security-group-rule',
#                             'Tags': [
#                                 {
#                                     'Key': 'CidrIp',
#                                     'Value': '10.10.0.0/16' 
#                                 },
#                                 {
#                                     'Key': 'GroupId',
#                                     'Value': 'sg-0b34d558e8c98492b' 
#                                 }, 
#                                 {
#                                     'Key': 'FromPort',
#                                     'Value': "-1"
#                                 },
#                                 {
#                                     'Key': 'ToPort',
#                                     'Value': "-1" 
#                                 },
#                                 {
#                                     'Key': 'IpProtocol',
#                                     'Value': '-1'
#                                 }
#                             ]
#                         }
#                         ]
#                 )
# else:
#     print('The Rule is already exist')


# VPCID = "vpc-0b494c81d2874d285"
# PEER_VPCID = "vpc-037aa9b16bd7c6a29"
# PEER_REGION = "us-east-2"
# REGION_VPC_MainRTId = "rtb-00870990715a324a7"
# PEER_REGIONVPC_MainRTId = "rtb-058e6254f813ba076"
# VPC_DatabaseSgId = "sg-0335a51025fda31f5"
# PEER_VPC_DatabaseSgId = "sg-0086cde1b9952c7c8"

# PEER_REGION_CONFIG = Config(
#     region_name = PEER_REGION
# )



# client = boto3.client('ec2')
# peer_region_client = boto3.clien('ec2', config=PEER_REGION_CONFIG)


# create_vpc_peering_connection = client.create_vpc_peering_connection(
#     # DryRun = True,
#     PeerVpcId = PEER_VPCID,
#     VpcId = VPCID, 
#     PeerRegion = PEER_REGION

# )

# print(create_vpc_peering_connection['VpcPeeringConnection']['VpcPeeringConnectionId'])


# VpcPeeringConnectionId = create_vpc_peering_connection['VpcPeeringConnection']['VpcPeeringConnectionId']

# time.sleep(5)

# accept_vpc_peering_connection  = peer_region_client.accept_vpc_peering_connection(
#     VpcPeeringConnectionId=VpcPeeringConnectionId
# )

# print(accept_vpc_peering_connection)

# vpc02_cidrblock = accept_vpc_peering_connection['VpcPeeringConnection']['AccepterVpcInfo']['CidrBlock'] 
# vpc01_cidrblock = accept_vpc_peering_connection['VpcPeeringConnection']['RequesterVpcInfo']['CidrBlock']

# try: 
#     authorize_security_group_ingress_for_Region1_DatabaseSg  = client.authorize_security_group_ingress(
#         GroupId= VPC_DatabaseSgId ,
#         CidrIp = vpc02_cidrblock,
#         FromPort = -1 ,
#         ToPort = -1 ,
#         IpProtocol = "-1"

#     )
# except:
#     print("An error occurred (InvalidPermission.Duplicate) when calling the AuthorizeSecurityGroupIngress operation: the specified rule peer  + {} , ALL, ALLOW  already exists".format(vpc02_cidrblock))
     

# try:
#      authorize_security_group_ingress_for_Region2_DatabaseSg = peer_region_client.authorize_security_group_ingress(
#         GroupId= PEER_VPC_DatabaseSgId ,
#         CidrIp = vpc01_cidrblock,
#         FromPort = -1 ,
#         ToPort = -1 ,
#         IpProtocol = "-1" 
#      )
# except:
#     print("An error occurred (InvalidPermission.Duplicate) when calling the AuthorizeSecurityGroupIngress operation: the specified rule peer  + {} , ALL, ALLOW  already exists".format(vpc01_cidrblock))
     

# try: 
#     create_route_vpc_region1 = client.create_route(
#         DestinationCidrBlock = vpc02_cidrblock,
#         RouteTableId = REGION_VPC_MainRTId ,
#         VpcPeeringConnectionId = VpcPeeringConnectionId
#     )
# except:
#     print("(RouteAlreadyExists) when calling the CreateRoute operation for " + vpc02_cidrblock)

# try: 
#     create_route_vpc_region2 = peer_region_client.create_route(
#         DestinationCidrBlock = vpc01_cidrblock,
#         RouteTableId =PEER_REGIONVPC_MainRTId,
#         VpcPeeringConnectionId = VpcPeeringConnectionId
#     )
# except:
#         print("(RouteAlreadyExists) when calling the CreateRoute operation for " + vpc01_cidrblock)