
import json
import boto3
from botocore.config import Config
import cfnresponse
import time

def lambda_handler(event, context):
    # TODO implement
    print("Received event: " + json.dumps(event, indent=2))
    responseData={}
    VPCID=event['ResourceProperties']['VPCID']
    PEER_VPCID = event['ResourceProperties']['PEER_VPCID']
    PEER_REGION = event['ResourceProperties']['PEER_REGION']
    REGION_VPC_MainRTId = event['ResourceProperties']['REGION_VPC_MainRTId']
    PEER_REGIONVPC_MainRTId = event['ResourceProperties']['PEER_REGIONVPC_MainRTId']
    VPC_DatabaseSgId = event['ResourceProperties']['VPC_DatabaseSgId']
    PEER_VPC_DatabaseSgId = event['ResourceProperties']['PEER_VPC_DatabaseSgId']
    vpc01_cidrblock = ""
    vpc02_cidrblock = ""
    VpcPeeringConnectionId = ""
        
    PEER_REGION_CONFIG = Config(
        region_name = PEER_REGION
    )
    
    
    client = boto3.client('ec2')
    peer_region_client = boto3.client('ec2', config=PEER_REGION_CONFIG)
    
    try:
        if event['RequestType'] == 'Create' or event['RequestType'] == 'Update' :
            create_vpc_peering_connection = client.create_vpc_peering_connection(
            # DryRun = True,
            PeerVpcId = PEER_VPCID,
            VpcId = VPCID, 
            PeerRegion = PEER_REGION
        
            ) 
           
            print(create_vpc_peering_connection['VpcPeeringConnection']['VpcPeeringConnectionId'])
            
            
            VpcPeeringConnectionId = create_vpc_peering_connection['VpcPeeringConnection']['VpcPeeringConnectionId']
            
            time.sleep(10)
            
            accept_vpc_peering_connection  = peer_region_client.accept_vpc_peering_connection(
                VpcPeeringConnectionId=VpcPeeringConnectionId
            )
            
            print(accept_vpc_peering_connection)
            
            vpc02_cidrblock = accept_vpc_peering_connection['VpcPeeringConnection']['AccepterVpcInfo']['CidrBlock'] 
            vpc01_cidrblock = accept_vpc_peering_connection['VpcPeeringConnection']['RequesterVpcInfo']['CidrBlock']
            
            authorize_security_group_ingress_for_Region1_DatabaseSg  = client.authorize_security_group_ingress(
                    GroupId= VPC_DatabaseSgId ,
                    CidrIp = vpc02_cidrblock,
                    FromPort = -1 ,
                    ToPort = -1 ,
                    IpProtocol = "-1",
                    TagSpecifications = [
                       {
                        'Tags': [
                            {
                                'Key': 'CidrIp',
                                'Value': vpc02_cidrblock
                            },
                            {
                                'Key': 'From',
                                'Value': 'Peer DB Servers'
                            }
                        ]
                       }
                    ]
            )
     
            authorize_security_group_ingress_for_Region2_DatabaseSg = peer_region_client.authorize_security_group_ingress(
                    GroupId= PEER_VPC_DatabaseSgId ,
                    CidrIp = vpc01_cidrblock,
                    FromPort = -1 ,
                    ToPort = -1 ,
                    IpProtocol = "-1" 
                 )

            create_route_vpc_region1 = client.create_route(
                    DestinationCidrBlock = vpc02_cidrblock,
                    RouteTableId = REGION_VPC_MainRTId ,
                    VpcPeeringConnectionId = VpcPeeringConnectionId
                )

            create_route_vpc_region2 = peer_region_client.create_route(
                    DestinationCidrBlock = vpc01_cidrblock,
                    RouteTableId =PEER_REGIONVPC_MainRTId,
                    VpcPeeringConnectionId = VpcPeeringConnectionId
                )

        elif event['RequestType'] == 'Delete' :
             print("Request Type:",event['RequestType'])
             revoke_security_group_ingress_for_Region1_DatabaseSg  = client.revoke_security_group_ingress(
                    GroupId= VPC_DatabaseSgId ,
                    CidrIp = vpc02_cidrblock,
                    FromPort = -1 ,
                    ToPort = -1 ,
                    IpProtocol = "-1"
            )
             if revoke_security_group_ingress_for_Region1_DatabaseSg['Return']:
                print("Ingress asscess for {} to {}  has been revoked".format(vpc02_cidrblock, VPC_DatabaseSgId))

             revoke_security_group_ingress_for_Region2_DatabaseSg = peer_region_client.revoke_security_group_ingress(
                    GroupId= PEER_VPC_DatabaseSgId ,
                    CidrIp = vpc01_cidrblock,
                    FromPort = -1 ,
                    ToPort = -1 ,
                    IpProtocol = "-1" 
                 )
             if revoke_security_group_ingress_for_Region1_DatabaseSg['Return']:
                print("Ingress asscess for {} to {}  has been revoked".format(vpc01_cidrblock, PEER_VPC_DatabaseSgId))  

             print("Deleting route for Local Region Main Route Table" )
             delete_route_vpc_region1 = client.delete_route(
                    DestinationCidrBlock = vpc02_cidrblock,
                    RouteTableId = REGION_VPC_MainRTId ,
                  
                )
             print("Deleting route for Peer Region Main Route Table")
             delete_route_vpc_region2 = peer_region_client.delete_route(
                    DestinationCidrBlock = vpc01_cidrblock,
                    RouteTableId =PEER_REGIONVPC_MainRTId,
                 
                )     
             

             print('Deleting VPC Peering Connection')
             describe_vpc_peering_connections = client.describe_vpc_peering_connections(
                    Filters=[
                        {
                            'Name': 'requester-vpc-info.vpc-id',
                            'Values': [
                                VPCID
                            ]
                        },
                                                {
                            'Name': 'accepter-vpc-info.vpc-id',
                            'Values': [
                                PEER_VPCID
                            ]
                        },
                    ],

            )
             VpcPeeringConnectionId = describe_vpc_peering_connections['VpcPeeringConnections'][0]['VpcPeeringConnectionId']
             delete_vpc_peering_connection = client.delete_vpc_peering_connection(
                VpcPeeringConnectionId=VpcPeeringConnectionId
            )
             if delete_vpc_peering_connection['Return'] :
                print("Deleting VPC Peering Connection was Successful.")
             cfnresponse.send(event, context, 'SUCCESS', {}, "CustomResourcePhysicalID")                       

    except Exception as e:
        print('Failed to process:')
        print(e)
        responseStatus = 'FAILED'
        responseData = {'Failure': 'Something bad happened'}
        print(responseData)
        cfnresponse.send(event, context, responseStatus, responseData, "CustomResourcePhysicalID")