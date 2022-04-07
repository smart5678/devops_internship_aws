#!venv/bin/python
import os

import boto3
import botocore.exceptions
from dotenv import load_dotenv


if os.path.exists('.env'):
    load_dotenv('.env', override=True)

AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
MFA_DEVICE_ARN = os.getenv('MFA_DEVICE_ARN')


def make_export(file_name, session_token):
    with open(file_name, 'w') as f:
        f.write("#!/bin/bash\n")
        f.write(f"export AWS_SESSION_TOKEN={session_token.get('Credentials').get('SessionToken')}\n")
        f.write(f"export AWS_SECRET_ACCESS_KEY={session_token.get('Credentials').get('SecretAccessKey')}\n")
        f.write(f"export AWS_ACCESS_KEY_ID={session_token.get('Credentials').get('AccessKeyId')}\n")

    os.chmod(file_name, 0o755)
    print(f'Now You can put AWS credentials to environment with command:')
    print(f"./{file_name}")


print('Create boto3 Client.')
client = boto3.client(
    'sts',
    region_name='eu-central-1',
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
)
session_token = None

token = input('Input AWS MFA token: ')
try:
    print('Take Session Token.')
    session_token = client.get_session_token(SerialNumber=MFA_DEVICE_ARN, TokenCode=token)
    print('Session token received.')
except botocore.exceptions.ClientError as e:
    print(e)

if session_token is not None:
    make_export('export.sh', session_token)
