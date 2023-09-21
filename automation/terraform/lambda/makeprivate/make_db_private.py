from __future__ import print_function
import json
import boto3


SUCCESS = "SUCCESS"
FAILED = "FAILED"


print('Loading function')
client = boto3.client('ec2')

def lambda_handler(event, context):
    responseData={}
    try:
            print(event)
            VPCID=event['VPCID']
            DBSUBNETID=event['DBSUBNETID']
            # AssociationId=event['ResourceProperties']['AssociationId']
            print("VPCID is :", VPCID)
            disable_dbsubnet_public(VPCID,DBSUBNETID)
            responseData={'LOCKDOWN':True}
            print(responseData)
            responseStatus = 'SUCCESS'
            print("responseStatus: " + responseStatus)
            return {
                'responseData': responseData,
                'responseStatus': responseStatus 
            }
          
    except Exception as e:
        print('Failed to process:', e)
        responseStatus = 'FAILED'
        responseData = {'Failure': 'Something bad happened.'}
        return {
                'responseData': 'NULL',
                'responseStatus': responseStatus 
            }


def disable_dbsubnet_public(VPCID, DBSUBNETID):
    client.modify_subnet_attribute(
        MapPublicIpOnLaunch={
            'Value': False
        },
        SubnetId=DBSUBNETID,

    )

    response = client.describe_route_tables(

    Filters = [
        {
        'Name': 'association.subnet-id',
        'Values': [ DBSUBNETID ]
        },
        {
            'Name': 'vpc-id',
            'Values': [ VPCID ]
        }
    ]
    )
    AssociationId = ""
    for rt in response['RouteTables']:
        for rt_assoc in rt['Associations']:
            if rt_assoc['SubnetId'] == DBSUBNETID :
                AssociationId = rt_assoc['RouteTableAssociationId']
                break

    # AssociationId = response['RouteTables'][0]['Associations'][0]['RouteTableAssociationId']
    #detach dbsubnet to publicRT
    client.disassociate_route_table(
        AssociationId=AssociationId
        
    )


    response = client.describe_route_tables(
    Filters = [
        {
        'Name': 'association.main',
        'Values': [ 'true' ]
        },
        {
            'Name': 'vpc-id',
            'Values': [ VPCID ]
        }
    ]
    )

    MainRTId = response['RouteTables'][0]['RouteTableId']

    client.associate_route_table(
    RouteTableId = MainRTId,
    SubnetId =DBSUBNETID,
    
    )

