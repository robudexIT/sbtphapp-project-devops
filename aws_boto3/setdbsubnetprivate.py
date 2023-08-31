import boto3

client = boto3.client('ec2')

# client.modify_subnet_attribute(
#     MapPublicIpOnLaunch={
#         'Value': False
#     },
#     SubnetId='subnet-04ad75005ec632e84',

#  )
# AssociationId = "rtbassoc-047da728122feabfd"
VPCID = "vpc-026c5079d314588c8"
DBSUBNETID = "subnet-0178b134a832022f4"
PUBLICRT= "rtb-0c366efe3c530806f"

response = client.describe_route_tables(

    Filters = [
        {
        'Name': 'association.subnet-id',
        'Values': [DBSUBNETID]
        },
        {
          'Name': 'vpc-id',
          'Values': [VPCID]
        },
     
    ]
)
AssociationId = ""
for rt in response['RouteTables']:
    for rt_assoc in rt['Associations']:
        if rt_assoc['SubnetId'] == DBSUBNETID :
            AssociationId = rt_assoc['RouteTableAssociationId']
            break


print(AssociationId)
# AssociationId = response['RouteTables'][0]['Associations'][0]['RouteTableAssociationId']

# print(len(response['route-table-id'][0]['Ipv6CidrBlockAssociationSet']))
# print(response['RouteTables'][0]['Associations'][1]['SubnetId'])
#detach dbsubnet to publicRT
# client.disassociate_route_table(
#     AssociationId=AssociationId
    
# )


# response = client.describe_route_tables(
#     Filters = [
#         {
#         'Name': 'association.main',
#         'Values': ['true']
#         },
#         {
#           'Name': 'vpc-id',
#           'Values': [VPCID]
#         }
#     ]
# )

# MainRTId = response['RouteTables'][0]['RouteTableId']
# print(response['RouteTables'][0]['RouteTableId'])
# response = client.associate_route_table(
#     RouteTableId = MainRTId,
#     SubnetId = DBSUBNETID,
   
# )





