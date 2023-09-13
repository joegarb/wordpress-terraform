#!/bin/bash

# Update this instance's own IP address in Route 53
# This is needed since the instance's IP changes on reboot and we aren't using an elastic IP.
# https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o

TOKEN=$(curl -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s -X PUT "http://169.254.169.254/latest/api/token")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id/)
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
MY_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/public-ipv4/)

ZONE_TAG=$(aws ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`AUTO_DNS_ZONE`].Value' --output text)
NAME_TAG=$(aws ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`AUTO_DNS_NAME`].Value' --output text)

aws route53 change-resource-record-sets --hosted-zone-id $ZONE_TAG --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$NAME_TAG'","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$MY_IP'"}]}}]}'
