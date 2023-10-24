import json
import gzip
import base64
import os
from urllib.parse import urlencode
from urllib.request import Request, urlopen

team = os.environ['team']
GenieKey = 'GenieKey ' + os.environ['GenieKey']
service = os.environ['service']

def lambda_handler(event, context):

    # print(event)

    # get log event
    cloudwatch_event = event['awslogs']['data']

    # log event is encoded using vase 64. decode it
    decoded_event = base64.b64decode(cloudwatch_event)

    # log events is compressed. unzip it
    decompressed_event = gzip.decompress(decoded_event)
    # print(decompressed_event)

    # convert JSON string to python dictionary
    log_data = json.loads(decompressed_event)
    logEvents = log_data['logEvents']

    for log_event in logEvents:
        log = log_event['message']

        url = 'https://api.eu.opsgenie.com/v2/alerts'

        post_fields = {
            "message": service + " Error",
            "description": log,
            "responders": [
                {
                    "name": team,
                    "type": "team"

                }
            ],
            "priority": "P3"
        }

        request = Request(url, json.dumps(post_fields).encode('utf-8'))
        request.add_header('Content-Type', 'application/json')
        request.add_header(
            'Authorization', GenieKey )

        resp = urlopen(request).read().decode()
        print(resp)