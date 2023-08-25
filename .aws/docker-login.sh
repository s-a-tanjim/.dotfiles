#!/bin/bash

########################################
#       Docker Login for AWS ECR       #
########################################

AWS_REGION=us-east-1
USER_ID=
AWS_PROFILE=ecr-access


ARN=$USER_ID.dkr.ecr.$AWS_REGION.amazonaws.com

aws ecr get-login-password --profile $AWS_PROFILE | docker login --username AWS --password-stdin $ARN
