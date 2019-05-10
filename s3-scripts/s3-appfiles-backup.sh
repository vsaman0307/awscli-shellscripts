#!/bin/sh

function usage() {
  echo "$0 s3-bucket-name files-folder"
}

if [ $# -ne 2 ]; then
  usage
  exit 2
fi

S3_BUCKET=$1
BACKUP_FILES_FOLDER=$2

# Filename for logging
_nowDate=$(date +"%Y_%m_%d_%H_%M_%S")
_logsDir="${HOME}/Documents/awscli-logs"   
_logFile="awscli-s3-files-backup-$_nowDate.log"

#Directory to backup
SOURCE_DIR=$BACKUP_FILES_FOLDER

#Destination directory and S3 bucket
DEST_DIR=${_logsDir}
DEST_BUCKET=$S3_BUCKET

# Output files
FILES_OUTPUT=$DEST_DIR/files.$_nowDate.zip

# Back up files
echo "Creating zip folder" >> ${_logsDir}/${_logFile}
zip -r $FILES_OUTPUT $SOURCE_DIR >> ${_logsDir}/${_logFile}

# Upload to S3
echo "Uploading zip file to S3 bucket : $S3_BUCKET" >> ${_logsDir}/${_logFile}
aws s3 cp $FILES_OUTPUT s3://$DEST_BUCKET >> ${_logsDir}/${_logFile}

# Remove files older than 14 days
find $DEST_DIR -type f -mtime +14 | xargs rm -f

exit 0
