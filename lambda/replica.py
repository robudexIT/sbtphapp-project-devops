
import boto3
from botocore.config import Config

myconfig = Config(
    region_name = "us-east-2"
    
)
client = boto3.client('rds', config=myconfig)


# response = client.create_db_instance_read_replica(
#     DBInstanceIdentifier='dbreplicainstance',
#     SourceDBInstanceIdentifier='arn:aws:rds:us-east-1:427875724091:db:sbtphappdbinstances',
#     DBInstanceClass='db.t3.micro',
#     MultiAZ= False,
#     DBSubnetGroupName='dbsubnetgroupregion2',
#     PubliclyAccessible=False,
#     SourceRegion='us-east-1',
#     VpcSecurityGroupIds = [
#         "sg-04a88a1e6709ab421"
#     ]
# )


response = client.describe_db_instances(
    DBInstanceIdentifier='dbreplicainstance',

)

print(response['DBInstances'][0]['DBInstanceStatus'])
