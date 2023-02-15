#!/bin/bash

# To Run(Including source variable): `$ . ./connect-mfa.sh`


# Dependencies
# - jq

ARN_VALUE=arn:aws:iam::*:mfa/*

echo Enter Auth Code:
read TOKEN_CODE


read -r -d '' OUTPUT << EOM
$(aws sts get-session-token --serial-number $ARN_VALUE --token-code $TOKEN_CODE)
EOM


export AWS_ACCESS_KEY_ID=$(echo $OUTPUT | jq .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $OUTPUT | jq .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $OUTPUT | jq .Credentials.SessionToken)
export AWS_TOKEN_EXPIRATION=$(echo $OUTPUT | jq .Credentials.Expiration)

echo '\nAWSAccessKeyID: '
echo $AWS_ACCESS_KEY_ID
echo '\nAWSSecretAccessKey: '
echo $AWS_SECRET_ACCESS_KEY
echo '\nAWSSessionToken: '
echo $AWS_SESSION_TOKEN
echo '\nAWSTokenExpiration: '
echo $AWS_TOKEN_EXPIRATION

# export $ACCESS_KEY_ID
# export $SECRET_ACCESS_KEY
# export $SESSION_TOKEN
