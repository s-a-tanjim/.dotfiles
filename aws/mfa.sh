#!/bin/bash

# Dependencies
# - jq

ARN_VALUE=''

echo Enter Auth Code:
read TOKEN_CODE


read -r -d '' OUTPUT << EOM
$(aws sts get-session-token --serial-number $ARN_VALUE --token-code $TOKEN_CODE)
EOM

ACCESS_KEY_ID=$(echo $OUTPUT | jq .Credentials.AccessKeyId)
SECRET_ACCESS_KEY=$(echo $OUTPUT | jq .Credentials.SecretAccessKey)
SESSION_TOKEN=$(echo $OUTPUT | jq .Credentials.SessionToken)


export $ACCESS_KEY_ID
export $SECRET_ACCESS_KEY
export $SESSION_TOKEN
