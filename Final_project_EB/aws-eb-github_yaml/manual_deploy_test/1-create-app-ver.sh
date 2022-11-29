#!/bin/bash
REGION="eu-central-1"
ZIP_PACK="pyapp.zip"
S3_BUCKET="anpod07-rds"
APP_NAME="test-rds-pyapp"
AWS_PLATFORM="Python"
AWS_ID="SSH_key_Frankfurt"

aws elasticbeanstalk create-application-version \
        --application-name ${APP_NAME} \
        --version-label Sample-5 \
        --region ${REGION} \
        --source-bundle S3Bucket="${S3_BUCKET}",S3Key="${ZIP_PACK}" \
        --auto-create-application
