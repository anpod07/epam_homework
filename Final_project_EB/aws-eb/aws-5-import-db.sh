#!/bin/bash
#----------------------------#
# Import DB 'db-test' to RDS #
#----------------------------#
APP_NAME="test-rds-pyapp"
AWS_ID="SSH_key_Frankfurt"
DB_PATH="/home/andr/mysql_tables_backup/db/db_test.sql"

# Get EB EntryPoint
ebip="$(eb status ${APP_NAME}-env | grep "CNAME" | awk '{print $2}')"
host $ebip

# Get RDS EntryPoint
rdsip="$(aws rds describe-db-instances \
  --db-instance-identifier "rds-mysql" \
  --query "DBInstances[*].Endpoint.Address" \
  --output text)"
echo $rdsip

# Declare some SSH Options
sshoptions="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/andr/.ssh/$AWS_ID.pem"

# Test SSH-connection
#ssh $(echo $sshoptions) ec2-user@$ebip "uname -a && sudo whoami"

# Create SSH-Port-Forwarding
ssh $(echo $sshoptions) ec2-user@$ebip -N -L 23306:$rdsip:3306 &
sleep 1
ss -ltn | grep 23306

# Import DB 'db-test' to RDS
mysql -h 127.0.0.1 -u admin -p07secret07 -P 23306 < $DB_PATH
sleep 1

# Check for installed DB 'db_test'
mysql -h 127.0.0.1 -u admin -p07secret07 -P 23306 -e "show databases; use db_test; show tables;"

# Close SSH-Port-Forwarding
kill $(ps aux | grep "$ebip" | grep ssh | awk '{print $2}')
sleep 1
ps aux | grep "ssh"
