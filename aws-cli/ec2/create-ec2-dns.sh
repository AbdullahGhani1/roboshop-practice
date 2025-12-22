#!/bin/bash

ZONE_NAME="sixdevops.store"
TTL=30

HZ_ID=$(aws route53 list-hosted-zones \
  --query "HostedZones[?Name=='sixdevops.store.'].Id | [0]" \
  --output text | cut -d'/' -f3)

aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value | [0], PrivateIpAddress]" \
  --output text | while read TAG_NAME PRIVATE_IP
do
  if [[ -z "$TAG_NAME" || -z "$PRIVATE_IP" ]]; then
    continue
  fi

  RECORD_NAME=$(echo "$TAG_NAME" | tr '[:upper:]' '[:lower:]').$ZONE_NAME

  cat <<EOF > /tmp/dns-$TAG_NAME.json
{
  "Comment": "Auto DNS for EC2 $TAG_NAME",
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "$RECORD_NAME",
      "Type": "A",
      "TTL": $TTL,
      "ResourceRecords": [{
        "Value": "$PRIVATE_IP"
      }]
    }
  }]
}
EOF

  aws route53 change-resource-record-sets \
    --hosted-zone-id $HZ_ID \
    --change-batch file:///tmp/dns-$TAG_NAME.json

  echo "Created DNS: $RECORD_NAME -> $PRIVATE_IP"
done
