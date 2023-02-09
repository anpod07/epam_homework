#!/usr/bin/env bash
# bootstrapping nginx-loadbalancer-http
echo "============================= START ============================="
apt update
apt install nginx awscli -y
aws s3 cp s3://anpod07-share/utils/default.lb /etc/nginx/sites-available/default
systemctl restart nginx
systemctl enable nginx
echo "============================= STOP ============================="
