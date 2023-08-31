import boto3

client = boto3.client('ec2')

VPCID = "vpc-0a745e695872bcbf5"
DBSUBNETID = "subnet-07c072b89c1163c5c"
PublicRT= "rtb-06db6453851850e88"

client.modify_subnet_attribute(
    MapPublicIpOnLaunch={
        'Value': True
    },
    SubnetId=DBSUBNETID

)
#associte in public route to gain internet access
client.associate_route_table(
    RouteTableId=PublicRT,
    SubnetId=DBSUBNETID 
   
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

AssociationId = response['RouteTables'][0]['Associations'][0]['RouteTableAssociationId']

print(AssociationId)



