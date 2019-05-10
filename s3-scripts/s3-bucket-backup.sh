#!/bin/sh

function usage() {
  echo "$0 s3-bucket-name s3-copy-bucket-name"
}

if [ $# -ne 2 ]; then
  usage
  exit 2
fi

S3_BUCKET=$1
S3_NEW_BUCKET=$2

# Filename for logging
_nowDate=`date -u "+%Y%m%d-%H%M%S-%Z" | tr [A-Z] [a-z]`
_logsDir="${HOME}/Documents/awscli-logs"   
_logFile="awscli-s3-bucket-backup-$_nowDate.log"

#Creating new bucket
echo "Creating New Bucket : $S3_NEW_BUCKET" >> ${_logsDir}/${_logFile}
s3_bucket_create=`aws s3 mb s3://$S3_NEW_BUCKET >> ${_logsDir}/${_logFile}`

#Copying files from bucket to newly created bucket 
s3_bucket_copy=`aws s3 sync s3://$S3_BUCKET s3://$S3_NEW_BUCKET >> ${_logsDir}/${_logFile}`

exit 0
