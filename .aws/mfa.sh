#!/bin/bash

#################################################
##       AWS Profile Set For MFA on CLI        ##
#################################################


# To Run(with sourcing variable): `$ . ./connect-mfa.sh`

# Dependencies
# - jq
# - aws-cli


####   SET ENV VARIABLES!   ####
ARN_VALUE=arn:aws:iam::*:mfa/*
AWS_REGION=ap-southeast-1
PROFILE=mfa-profile


read -p "Enter Auth Code: " TOKEN_CODE

read -r -d '' OUTPUT << EOM
$(aws sts get-session-token --serial-number $ARN_VALUE --token-code $TOKEN_CODE)
EOM


export AWS_ACCESS_KEY_ID=$(echo $OUTPUT | jq --raw-output .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $OUTPUT | jq --raw-output .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $OUTPUT | jq --raw-output .Credentials.SessionToken)
export AWS_TOKEN_EXPIRATION=$(echo $OUTPUT | jq --raw-output .Credentials.Expiration)

echo -e '\nAWSAccessKeyID: '
echo $AWS_ACCESS_KEY_ID
echo -e '\nAWSSecretAccessKey: '
echo $AWS_SECRET_ACCESS_KEY
echo -e '\nAWSSessionToken: '
echo $AWS_SESSION_TOKEN
echo -e '\nAWSTokenExpiration: '
echo $AWS_TOKEN_EXPIRATION

aws configure set region $AWS_REGION --profile $PROFILE
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile $PROFILE
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile $PROFILE
aws configure set aws_session_token $AWS_SESSION_TOKEN --profile $PROFILE

echo 'AWS Profile:'
aws configure list-profiles
