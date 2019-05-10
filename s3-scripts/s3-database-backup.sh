#!/bin/sh

function usage() {
  echo "$0 s3-bucket-name db-name"
}

if [ $# -ne 2 ]; then
  usage
  exit 2
fi

S3_BUCKET=$1
BACKUP_DB=$2

# Database credentials
DATABASE="DBNAME"
USERNAME="DBUSER"
PASSWORD="MYPASSWORD"

# Filename for logging
_nowDate=$(date +"%Y_%m_%d_%H_%M_%S")
_logsDir="${HOME}/Documents/awscli-logs"   
_logFile="awscli-s3-db-backup-$_nowDate.log"

#Destination directory and S3 bucket
DEST_DIR=${_logsDir}
DEST_BUCKET=$S3_BUCKET

# Output db 
DB_OUTPUT=$DEST_DIR/db.$NOW.sql.gz

# Back up database
echo "Creating database dump file and gzip" >> ${_logsDir}/${_logFile}
mysqldump -u $USERNAME -p"$PASSWORD" $DATABASE --single-transaction | gzip > $DB_OUTPUT


# Upload to S3
echo "Uploading gzip file to S3 bucket : $S3_BUCKET" >> ${_logsDir}/${_logFile}
aws s3 cp $DB_OUTPUT s3://$DEST_BUCKET >> ${_logsDir}/${_logFile}

# Remove files older than 14 days
find $DEST_DIR -type f -mtime +14 | xargs rm -f

exit 0
