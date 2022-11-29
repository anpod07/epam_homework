#!/bin/bash
REGION="eu-central-1"
ZIP_PACK="pyapp.zip"
S3_BUCKET="anpod07-rds"
APP_NAME="test-rds-pyapp"
AWS_PLATFORM="Python"
AWS_ID="SSH_key_Frankfurt"

aws elasticbeanstalk update-environment --environment-name ${APP_NAME}-env --version-label "Sample-5"
