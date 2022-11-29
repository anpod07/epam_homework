#!/usr/bin/env bash
# Развертывание базового EB
APP_NAME="test-rds-pyapp"
AWS_PLATFORM="Python"
AWS_PLATFORM_ARN="arn:aws:elasticbeanstalk:eu-central-1::platform/Python 3.8 running on 64bit Amazon Linux 2/3.4.1"
AWS_ID="SSH_key_Frankfurt"
AWS_REGION="eu-central-1"

# Создание EB-Aplication
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-init.html
if [ -x ".elasticbeanstalk" ]
 then echo "application has been already initialized..."
 else eb init -i $APP_NAME -p $AWS_PLATFORM -k $AWS_ID --region $AWS_REGION
fi

# Получение ID: VPC, Subnets, Security Group
# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-vpcs.html
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=ansible_VPC_RDS" \
  --query "Vpcs[*].VpcId" \
  --output text)
echo $VPC_ID

# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-subnets.html
SUBNET_PRIVATE_1=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=ansible_RDS_Private_AZ_1" \
  --query "Subnets[*].SubnetId" \
  --output text)
SUBNET_PRIVATE_2=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=ansible_RDS_Private_AZ_2" \
  --query "Subnets[*].SubnetId" \
  --output text)
SUBNET_PUBLIC_1=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=ansible_RDS_Public_AZ_1" \
  --query "Subnets[*].SubnetId" \
  --output text)
SUBNET_PUBLIC_2=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=ansible_RDS_Public_AZ_2" \
  --query "Subnets[*].SubnetId" \
  --output text)
SUBNETS_PRIVATE="$SUBNET_PRIVATE_1,$SUBNET_PRIVATE_2"
SUBNETS_PUBLIC="$SUBNET_PUBLIC_1,$SUBNET_PUBLIC_2"
echo $SUBNETS_PRIVATE
echo $SUBNETS_PUBLIC

# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-security-groups.html
SGROUP=$(aws ec2 describe-security-groups \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Name,Values=ansible_SG_EB" \
  --query "SecurityGroups[*].GroupId" \
  --output text)
echo $SGROUP

# Создание EB-Environment для Application
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-create.html
if grep -q 'ERROR:' <<< $(eb status)
 then
  eb create ${APP_NAME}-env \
    --instance-types t2.micro,t2small \
    --instance-type t2.micro \
    --keyname $AWS_ID \
    --platform "$AWS_PLATFORM_ARN" \
    --region $AWS_REGION \
    --sample \
    --single \
    --tags "Name=my-eb-stage","owner=ninja" \
    --vpc.id $VPC_ID \
    --vpc.dbsubnets $SUBNETS_PRIVATE \
    --vpc.ec2subnets $SUBNETS_PUBLIC \
    --vpc.securitygroup $SGROUP
  EB_CNAME="$(eb status ${APP_NAME}-env | grep "CNAME" | awk '{print $2}')"
  echo "EntryPoint: $EB_CNAME"
 else echo "environment already exist..."
fi
