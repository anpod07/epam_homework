#!/usr/bin/env bash
# bootstrapping mysql+pyapp in dockers
echo "============================= START ============================="
cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/authorized_keys
apt update
apt install docker.io awscli -y
systemctl start docker
systemctl enable docker
mkdir -p /opt/docker-proj
docker run -d -p 3306:3306 -v /opt/docker-proj/:/var/lib/mysql --rm --name my anpod07/my-db:latest
mkdir -p /opt/pyapp
aws s3 cp s3://anpod07-share/utils/pyapp /opt/pyapp/ --recursive
docker run -d -p 8000:8000 -v /opt/pyapp:/home/ninja/pyapp --rm --name my-pyapp anpod07/aws-pyapp:latest
echo "============================= STOP ============================="
