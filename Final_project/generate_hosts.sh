#!/bin/bash
# Get Public IP addresses of all our EC2
cat hosts.orig > hosts
echo -e "\n[epam]" >> hosts
aws ec2 describe-instances \
        --filters 'Name=private-ip-address,Values=172.31.23.*' \
        --query 'Reservations[*].Instances[*].PublicIpAddress' \
        --output text |\
 awk '{print $0, " ansible_user=ubuntu  ansible_ssh_private_key_file=~/.ssh/SSH_key_Frankfurt.pem"}' >> hosts
