import json
import boto3
from botocore.config import Config
import time

def lambda_handler(event, context):
    VPCID = "vpc-086cc458f431c6ed8"
    PEER_VPCID = "vpc-06ca52a45b571d43e"
    PEER_REGION = "us-east-2"
    REGION_VPC_MainRTId = ""
    PEER_REGIONVPC_MainRTId = ""
    VPC_DatabaseSgId = ""
    PEER_VPC_DatabaseSgId = ""

        
    PEER_REGION_CONFIG = Config(
        region_name = PEER_REGION
    )
    
    
    client = boto3.client('ec2')
    peer_region_client = boto3.client('ec2', config=PEER_REGION_CONFIG) 
    
    try:
        describe_route_tables = client.describe_route_tables(
            Filters = [
                {
                'Name': 'association.main',
                'Values': [ 'true']
                },
                {
                 'Name': 'vpc-id',
                 'Values':[ VPCID] 
                }
            ]    
        )
        
        REGION_VPC_MainRTId = describe_route_tables['RouteTables'][0]['RouteTableId']
    except:
        print('Failed in fetching REGION_VPC_MainRTId')
        
    try:
        describe_route_tables = peer_region_client.describe_route_tables(
            Filters = [
                {
                'Name': 'association.main',
                'Values': [ 'true']
                },
                {
                 'Name': 'vpc-id',
                 'Values': [ PEER_VPCID ]
                }
            ]    
        )
        
        PEER_REGIONVPC_MainRTId  = describe_route_tables['RouteTables'][0]['RouteTableId']
    except:
        print('Failed in fetching PEER_REGIONVPC_MainRTId ')
        
    try:
        describe_security_groups = client.describe_security_groups(
            Filters = [
             {
                 'Name': "tag:Name",
                 'Values': ['DatabaseSg']
             }    
            ]   
        )
        VPC_DatabaseSgId = describe_security_groups['SecurityGroups'][0]['GroupId']
    except:
        print('Failed  int fetching VPC_DatabaseSgId ')
        
    try:
        describe_security_groups = peer_region_client.describe_security_groups(
            Filters = [
             {
                 'Name': "tag:Name",
                 'Values': ['DatabaseSg']
             }    
            ]   
        )
        PEER_VPC_DatabaseSgId = describe_security_groups['SecurityGroups'][0]['GroupId']
    except:
        print('Failed  int fetching PEER_VPC_DatabaseSgId ')   
        
    data = {
         'REGION_VPC_MainRTId':  REGION_VPC_MainRTId,
         'PEER_REGIONVPC_MainRTId': PEER_REGIONVPC_MainRTId , 
         'VPC_DatabaseSgId': VPC_DatabaseSgId ,
         'PEER_VPC_DatabaseSgId': PEER_VPC_DatabaseSgId ,
         
    } 
    print(data)
    return {
         'statusCode': 200,
        'body': json.dumps(data)
    }
    

    
    
