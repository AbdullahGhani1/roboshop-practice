#!/bin/bash

REGION="us-east-1"
SG_NAME="allow-all-sg"

# 1. Dynamically find the VPC ID
VPC_ID=$(aws ec2 describe-vpcs \
    --query 'Vpcs[0].VpcId' \
    --output text \
    --region $REGION)

if [ "$VPC_ID" == "None" ] || [ -z "$VPC_ID" ]; then
    echo "Error: No VPC found in region $REGION."
    exit 1
fi

echo "Using VPC ID: $VPC_ID"

# 2. Create the Security Group
# We use || to catch if it exists, but for a dev script, creating a new one is standard.
SG_ID=$(aws ec2 create-security-group \
    --group-name "$SG_NAME" \
    --description "Microservices dev env: All traffic and SSH" \
    --vpc-id "$VPC_ID" \
    --region $REGION \
    --query 'GroupId' \
    --output text)

echo "Created Security Group ID: $SG_ID"

# 3. Add Inbound Rules
echo "Configuring Inbound Rules..."

# Rule A: All Traffic (covers all ports/protocols)
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol all \
    --cidr 0.0.0.0/0 \
    --region $REGION

# Rule B: Explicit SSH (Port 22) 
# Note: This is technically redundant if 'all' is enabled, but standard for documentation.
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \
    --region $REGION

echo "Security Group $SG_NAME configured successfully."