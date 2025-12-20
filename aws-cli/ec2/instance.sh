#!/bin/bash

# Configuration
AMI_ID="ami-0b4f379183e5706b9"
SG_NAME="allow-all-sg"
REGION="us-east-1"
INSTANCE_TYPE="t3.micro"

# List of microservices
services=("Frontend" "MongoDB" "Catalogue" "Redis" "User" "Cart" "MySQL" "Shipping" "RabbitMQ")

for service in "${services[@]}"; do
  echo "Deploying $service..."
  
  aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --security-groups $SG_NAME \
    --region $REGION \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$service}]" \
    --query 'Instances[0].InstanceId' \
    --output text

  echo "$service instance requested successfully."
done