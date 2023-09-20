import json
import boto3
import urllib3


SUCCESS = "SUCCESS"
FAILED = "FAILED"

http = urllib3.PoolManager()

print('Loading function')
client = boto3.client('ec2')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))
    responseData={}
    try:
        VPCID=event['VPCID']
        DBSUBNETID=event['DBSUBNETID']
        PUBLICRTID=event['PUBLICRTID']
        AssociationId=enable_dbsubnet_public(VPCID,DBSUBNETID,PUBLICRTID)
        print("Sending response to custom resource")
        responseStatus = 'SUCCESS'
        print("responseStatus: " + responseStatus)
        return {
            "responseStatus" : responseStatus,
            'AssociationId' : AssociationId
        }
    except Exception as e:
        print('Failed to process:', e)
        responseStatus = 'FAILED'
        responseData = {'Failure': 'Something bad happened.'}
        return {
                "responseStatus" : FAILED,
        }

def enable_dbsubnet_public(VPCID,DBSUBNETID,PUBLICRTID):
    
    response = client.describe_subnets(
        SubnetIds = [
            DBSUBNETID
        ]
    )
    MapPublicIpOnLaunch = response['Subnets'][0]['MapPublicIpOnLaunch']
    
    if MapPublicIpOnLaunch == False:
        
        client.modify_subnet_attribute(
            MapPublicIpOnLaunch={
                'Value': True
            },
            SubnetId=DBSUBNETID,

        )
    
    #associte in public route to gain internet access
    client.associate_route_table(
        RouteTableId=PUBLICRTID,
        SubnetId=DBSUBNETID,
        
    )
    response = client.describe_route_tables(
    Filters = [
        {
        'Name': 'association.subnet-id',
        'Values': [DBSUBNETID]
        },
        {
            'Name': 'vpc-id',
            'Values': [VPCID]
        }
    ]
    )

    # print("Printing the VPC Route Table ID ....")
    # RouteTableID=response['RouteTables'][0]['RouteTableId']
    # print(RouteTableID)
    AssociationId = response['RouteTables'][0]['Associations'][0]['RouteTableAssociationId']
    return AssociationId 
