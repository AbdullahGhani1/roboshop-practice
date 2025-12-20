Get Vpc Id

```sh
aws ec2 describe-vpcs \
    --query 'Vpcs[*].VpcId' \
    --output text \
    --region us-east-1
```

Get Ec2 Instance List

```sh
aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=running" \
    --query 'Reservations[*].Instances[*].{
        Name: Tags[?Key==`Name`].Value | [0],
        ID: InstanceId,
        Public: PublicIpAddress,
        Private: PrivateIpAddress
    }' \
    --output table
```

Get security group

```sh
aws ec2 describe-security-groups --group-ids $SG_ID --output table
```
