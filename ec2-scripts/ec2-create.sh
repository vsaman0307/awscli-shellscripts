#!/bin/sh

function usage() {
  echo "$0 ec2-config-file num_instances"
}

if [ $# -ne 2 ]; then
  usage
  exit 2
fi

DEBUG="echo "
DEBUG=""

CONFIG_FILE=$1
NUM_INSTANCES=$2

echo $1

FILE_CONTENTS=`cat "$CONFIG_FILE"` 
echo $FILE_CONTENTS

# ec2 parameters
EC2_AMI=`cat "$CONFIG_FILE" | jq '.imageId'`
EC2_INSTANCE=`cat "$CONFIG_FILE" | jq '.instanceType'`
EC2_KEY=`cat "$CONFIG_FILE" | jq '.keyName'`
EC2_SECURITY_GROUP_IDS=`cat "$CONFIG_FILE" | jq '.securityGroupIds'`
EC2_BLOCK_DEVICE_MAPPINGS=`cat "$CONFIG_FILE" | jq '.blockDeviceMappings'`
EC2_SUBNET_ID=`cat "$CONFIG_FILE" | jq '.subnetId'`
EC2_USER_DATA=`cat "$CONFIG_FILE" | jq '.userDataFile'`
EC2_TAG_SPECIFICATIONS=`cat "$CONFIG_FILE" | jq '.tagSpecifications'`
echo "EC2 AMI" .  $EC2_AMI
echo [$EC2_AMI]
echo "INSTANCE" $EC2_INSTANCE
echo EC2_KEY $EC2_KEY
echo SG $EC2_SECURITY_GROUP_IDS
echo subnet-id $EC2_SUBNET_ID

`aws ec2 run-instances --image-id $EC2_AMI --instance-type $EC2_INSTANCE --key-name $EC2_KEY --subnet $EC2_SUBNET_ID --region us-east-1`
#EC2_RUN=`aws ec2 run-instances --image-id "ami-0080e4c5bc078760e" --instance-type "t2.micro" --key-name "vasudha-key" --security-group-ids "sg-00994774d3b38e6f2" --subnet-id "subnet-f0ef8cde"`
INSTANCE_NAME=$(echo ${EC2_RUN_RESULT} | sed 's/RESERVATION.*INSTANCE //' | sed 's/ .*//')
echo "Instance Status is" $INSTANCE_NAME

times=0
echo
while [ 5 -gt $times ] && ! ec2-describe-instances $INSTANCE_NAME | grep -q "running"
do
  times=$(( $times + 1 ))
  echo Attempt $times at verifying $INSTANCE_NAME is running...
done


if [ 5 -eq $times ]; then
  echo Instance $INSTANCE_NAME is not running. Exiting...
  exit 0
fi


