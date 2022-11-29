#!/usr/bin/env bash
# bootstrapping nginx-loadbalancer-https
echo "============================= START ============================="
apt update
apt install nginx awscli -y
aws s3 cp s3://anpod07-share/utils/default.lbssl /etc/nginx/sites-available/default
aws s3 cp s3://anpod07-share/utils/certbot.tar.gz /opt/
tar xzf /opt/certbot.tar.gz -C /etc/
systemctl restart nginx
systemctl enable nginx
echo "============================= STOP ============================="
