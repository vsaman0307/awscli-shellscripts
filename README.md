# awscli-shellscripts
Linux shell scripts to perform various tasks for EC2 and S3 using Bash shell and AWS CLI commands.

# EC2 scripts

#Script to create n number of EC2 instances. The parameters for EC2 instances are specified in config file.
#Parameters are specified in json format (Ex: ec2-config.json) 
ec2-script.sh <config file> <number of instances>

#Script to start and stop or provide status for EC2 instances.
ec2-start-stop.sh <start | stop | status> <instance_id> <region>

#Script to create snapshots of EBS volumes and delete snapshots
ebs-snapshot.sh <backup | delete> <age>(age is optional only for delete snapshots)

# S3 scrips
#Script to backup files and upload zip file to S3 bucket
s3-appfiles-backup.sh <s3-bucket-name> <files-folder>

#Script to copy files from one bucket to another
s3-bucket-backup.sh <s3-bucket-name> <s3-copy-bucket-name>

#Script to create dump of mysql database, and store in S3 bucket
s3-database-backup.sh <s3-bucket-name> <db-name>

