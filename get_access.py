#!venv/bin/python
import os
from shutil import move
from tempfile import mkstemp
from dotenv import load_dotenv

import boto3
import botocore.exceptions

if os.path.exists('.env'):
    load_dotenv('.env', override=True)

AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
MFA_DEVICE_ARN = os.getenv('MFA_DEVICE_ARN')


def replace(source_file_path, session_token):
    fh, target_file_path = mkstemp()
    change = {'token': False, 'key_id': False, 'key': False}
    with open(target_file_path, 'w') as target_file:
        with open(source_file_path, 'r') as source_file:
            for line in source_file:
                if line.count('AWS_SESSION_TOKEN'):
                    target_file.write(f"AWS_SESSION_TOKEN={session_token.get('Credentials').get('SessionToken')}\n")
                    change['token'] = True
                elif line.count('AWS_ACCESS_KEY_ID'):
                    target_file.write(f"AWS_ACCESS_KEY_ID={session_token.get('Credentials').get('AccessKeyId')}\n")
                    change['key_id'] = True
                elif line.count('AWS_SECRET_ACCESS_KEY'):
                    target_file.write(
                        f"AWS_SECRET_ACCESS_KEY={session_token.get('Credentials').get('SecretAccessKey')}\n")
                    change['key'] = True
                else:
                    target_file.write(line)

            if not change['token']:
                target_file.write(f"AWS_SESSION_TOKEN={session_token.get('Credentials').get('SessionToken')}\n")
            if not change['key']:
                target_file.write(f"AWS_SECRET_ACCESS_KEY={session_token.get('Credentials').get('SecretAccessKey')}\n")
            if not change['key_id']:
                target_file.write(f"AWS_ACCESS_KEY_ID={session_token.get('Credentials').get('AccessKeyId')}\n")

    os.remove(source_file_path)
    move(target_file_path, source_file_path)


token = input('Input AWS token:')

client = boto3.client(
    'sts',
    region_name='eu-central-1',
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
)

session_token = None

try:
    session_token = client.get_session_token(SerialNumber=MFA_DEVICE_ARN, TokenCode=token)
except botocore.exceptions.ClientError as e:
    print(e)


def make_export(file_name, session_token):
    with open(file_name, 'w') as f:
        f.write("#!/bin/bash\n")
        f.write(f"export AWS_SESSION_TOKEN={session_token.get('Credentials').get('SessionToken')}\n")
        f.write(f"export AWS_SECRET_ACCESS_KEY={session_token.get('Credentials').get('SecretAccessKey')}\n")
        f.write(f"export AWS_ACCESS_KEY_ID={session_token.get('Credentials').get('AccessKeyId')}\n")
    print(f'Now You can put AWS credentials to environment via command:')
    print(f". ./{file_name}")


if session_token is not None:
    make_export('export.sh', session_token)
