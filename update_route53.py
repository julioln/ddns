import json
import boto3
import base64


client = boto3.client("route53")

HOSTED_ZONE_NAME = ""
RECORD_NAME = ""
RECORD_TYPE = "A"
RECORD_TTL = 300
SECRET = ""

def get_hosted_zone_id(name):
    name = f"{name}."
    response = client.list_hosted_zones()
    for zone in response["HostedZones"]:
        if zone["Name"] == name:
            return zone["Id"]


def main(event, context):
    try:
        id_ = get_hosted_zone_id(HOSTED_ZONE_NAME)

        print(event)

        if (event["isBase64Encoded"]):
            body = base64.b64decode(event["body"])
        else:
            body = event["body"]

        data = json.loads(body)
        print(data)

        if (data["secret"] != SECRET):
            raise Exception("Secret string does not match")

        ip = event["requestContext"]["http"]["sourceIp"]
        record = {
            "TTL": RECORD_TTL,
            "Type": RECORD_TYPE,
            "Name": RECORD_NAME,
            "ResourceRecords": [{"Value": ip}],
        }

        response = client.change_resource_record_sets(
            HostedZoneId=id_,
            ChangeBatch={
                "Changes": [{"Action": "UPSERT", "ResourceRecordSet": record}],
                "Comment": "Automatic DNS Update",
            },
        )

        body = {"message": "Record updated successfully", "record": record}
    except Exception as e:
        body = {"message": str(e)}
    return {"statusCode": 200, "body": json.dumps(body)}
