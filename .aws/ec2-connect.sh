#!/bin/bash

#####################################
# Connect to EC2 using EC2 Endpoint #
#####################################

# Requirement
# - aws-cli

SSH_KEY_PATH=~/.ssh

aws sts get-caller-identity --no-cli-pager || { echo 'Faild to authenticate. exiting...' ; exit 1; }


if [ -z "$AWS_REGION" ]; then
  read -p "AWS Region:(Default us-east-1) " AWS_REGION
  AWS_REGION=${AWS_REGION:-us-east-1}
else
  echo "Using AWS Region: $AWS_REGION"
fi

if [ -z "$EC2_INSTANCE_ID" ]; then
  read -p "EC2 Instance ID: " EC2_INSTANCE_ID
else
  echo "Using EC2 Instance ID: $EC2_INSTANCE_ID"
fi

if [ -z "$EC2_INSTANCE_AZ" ]; then
  read -p "EC2 Instance AZ: " EC2_INSTANCE_AZ
else
  echo "Using EC2 Instance AZ: $EC2_INSTANCE_AZ"
fi

if [ -z "$EC2_INSTANCE_ID" ] || [ -z "$EC2_INSTANCE_AZ" ]; then
  echo "Invalid input. Exiting..."
  exit 1
fi


if [ ! -f "$SSH_KEY_PATH/aws-ec2-access-key" ]
then
  echo Generating SSH Keypair...
  ssh-keygen -t rsa -q -N "" -f $SSH_KEY_PATH/aws-ec2-access-key
else
  echo SSH Key already exist. Skipping...
fi

echo "Sending SSH key to EC2..."
aws ec2-instance-connect send-ssh-public-key --region $AWS_REGION --instance-id $EC2_INSTANCE_ID --availability-zone $EC2_INSTANCE_AZ --instance-os-user ec2-user --no-cli-pager --ssh-public-key file://$SSH_KEY_PATH/aws-ec2-access-key.pub


ssh ec2-user@$EC2_INSTANCE_ID \
  -i $SSH_KEY_PATH/aws-ec2-access-key \
  -o ProxyCommand='aws ec2-instance-connect open-tunnel --instance-id $EC2_INSTANCE_ID' -o "IdentitiesOnly=yes"


# aws ec2-instance-connect ssh --instance-id $EC2_INSTANCE_ID --private-key-file $SSH_KEY_PATH/aws-ec2-access-key
# If need to open a tunnel
# aws ec2-instance-connect open-tunnel --instance-id $EC2_INSTANCE_ID --local-port 8898
