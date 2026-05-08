# Simple AWS Deployment Script for CIP Platform
$ErrorActionPreference = "Stop"

Write-Host "Starting AWS Deployment..." -ForegroundColor Green
Write-Host ""

$REGION = "us-east-1"
$KEY_NAME = "cip-platform-key"
$INSTANCE_TYPE = "t3.medium"
$AMI_ID = "ami-0e2c8caa4b6378d8c"

# Step 1: Create Key Pair
Write-Host "Step 1: Creating Key Pair..." -ForegroundColor Yellow
try {
    aws ec2 describe-key-pairs --key-names $KEY_NAME --region $REGION 2>$null | Out-Null
    Write-Host "Key pair already exists" -ForegroundColor Green
} catch {
    $keyPair = aws ec2 create-key-pair --key-name $KEY_NAME --region $REGION --query 'KeyMaterial' --output text
    $keyPair | Out-File -FilePath "$KEY_NAME.pem" -Encoding ASCII
    Write-Host "Key pair created: $KEY_NAME.pem" -ForegroundColor Green
}
Write-Host ""

# Step 2: Get VPC
Write-Host "Step 2: Getting VPC..." -ForegroundColor Yellow
$vpcId = aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --region $REGION --query 'Vpcs[0].VpcId' --output text
Write-Host "Using VPC: $vpcId" -ForegroundColor Green
Write-Host ""

# Step 3: Create EC2 Security Group
Write-Host "Step 3: Creating EC2 Security Group..." -ForegroundColor Yellow
try {
    $ec2SgId = aws ec2 describe-security-groups --filters "Name=group-name,Values=cip-ec2-sg" --region $REGION --query 'SecurityGroups[0].GroupId' --output text
    if ($ec2SgId -eq "None") { throw }
    Write-Host "Security group exists: $ec2SgId" -ForegroundColor Green
} catch {
    $ec2SgId = aws ec2 create-security-group --group-name "cip-ec2-sg" --description "CIP EC2 SG" --vpc-id $vpcId --region $REGION --query 'GroupId' --output text
    
    aws ec2 authorize-security-group-ingress --group-id $ec2SgId --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION | Out-Null
    aws ec2 authorize-security-group-ingress --group-id $ec2SgId --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION | Out-Null
    aws ec2 authorize-security-group-ingress --group-id $ec2SgId --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $REGION | Out-Null
    aws ec2 authorize-security-group-ingress --group-id $ec2SgId --protocol tcp --port 3000 --cidr 0.0.0.0/0 --region $REGION | Out-Null
    aws ec2 authorize-security-group-ingress --group-id $ec2SgId --protocol tcp --port 8080 --cidr 0.0.0.0/0 --region $REGION | Out-Null
    aws ec2 authorize-security-group-ingress --group-id $ec2SgId --protocol tcp --port 8000 --cidr 0.0.0.0/0 --region $REGION | Out-Null
    
    Write-Host "Security group created: $ec2SgId" -ForegroundColor Green
}
Write-Host ""

# Step 4: Create RDS Security Group
Write-Host "Step 4: Creating RDS Security Group..." -ForegroundColor Yellow
try {
    $rdsSgId = aws ec2 describe-security-groups --filters "Name=group-name,Values=cip-rds-sg" --region $REGION --query 'SecurityGroups[0].GroupId' --output text
    if ($rdsSgId -eq "None") { throw }
    Write-Host "RDS security group exists: $rdsSgId" -ForegroundColor Green
} catch {
    $rdsSgId = aws ec2 create-security-group --group-name "cip-rds-sg" --description "CIP RDS SG" --vpc-id $vpcId --region $REGION --query 'GroupId' --output text
    aws ec2 authorize-security-group-ingress --group-id $rdsSgId --protocol tcp --port 5432 --source-group $ec2SgId --region $REGION | Out-Null
    Write-Host "RDS security group created: $rdsSgId" -ForegroundColor Green
}
Write-Host ""

# Step 5: Create RDS Database
Write-Host "Step 5: Creating RDS Database..." -ForegroundColor Yellow
$DB_INSTANCE_ID = "cip-database"
$DB_PASSWORD = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 16 | ForEach-Object {[char]$_})

try {
    $dbInstance = aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_ID --region $REGION 2>$null | ConvertFrom-Json
    $dbEndpoint = $dbInstance.DBInstances[0].Endpoint.Address
    Write-Host "Database exists: $dbEndpoint" -ForegroundColor Green
} catch {
    Write-Host "Creating database (this takes 5-10 minutes)..." -ForegroundColor Yellow
    
    aws rds create-db-instance `
        --db-instance-identifier $DB_INSTANCE_ID `
        --db-instance-class db.t3.micro `
        --engine postgres `
        --engine-version 15.17 `
        --master-username postgres `
        --master-user-password $DB_PASSWORD `
        --allocated-storage 20 `
        --vpc-security-group-ids $rdsSgId `
        --db-name cip_db `
        --backup-retention-period 1 `
        --publicly-accessible `
        --region $REGION | Out-Null
    
    Write-Host "Waiting for database..." -ForegroundColor Yellow
    aws rds wait db-instance-available --db-instance-identifier $DB_INSTANCE_ID --region $REGION
    
    $dbInstance = aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_ID --region $REGION | ConvertFrom-Json
    $dbEndpoint = $dbInstance.DBInstances[0].Endpoint.Address
    
    @{
        DBEndpoint = $dbEndpoint
        DBPassword = $DB_PASSWORD
    } | ConvertTo-Json | Out-File -FilePath "db-credentials.json"
    
    Write-Host "Database created: $dbEndpoint" -ForegroundColor Green
    Write-Host "Credentials saved to: db-credentials.json" -ForegroundColor Yellow
}
Write-Host ""

# Step 6: Launch EC2 Instance
Write-Host "Step 6: Launching EC2 Instance..." -ForegroundColor Yellow
try {
    $instances = aws ec2 describe-instances --filters "Name=tag:Name,Values=cip-platform" "Name=instance-state-name,Values=running,pending" --region $REGION | ConvertFrom-Json
    if ($instances.Reservations.Count -gt 0) {
        $instanceId = $instances.Reservations[0].Instances[0].InstanceId
        Write-Host "Instance exists: $instanceId" -ForegroundColor Green
    } else {
        throw
    }
} catch {
    $instanceId = aws ec2 run-instances `
        --image-id $AMI_ID `
        --instance-type $INSTANCE_TYPE `
        --key-name $KEY_NAME `
        --security-group-ids $ec2SgId `
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=cip-platform}]' `
        --block-device-mappings 'DeviceName=/dev/sda1,Ebs={VolumeSize=30,VolumeType=gp3}' `
        --region $REGION `
        --query 'Instances[0].InstanceId' `
        --output text
    
    Write-Host "Waiting for instance..." -ForegroundColor Yellow
    aws ec2 wait instance-running --instance-ids $instanceId --region $REGION
    Write-Host "Instance launched: $instanceId" -ForegroundColor Green
}
Write-Host ""

# Step 7: Allocate Elastic IP
Write-Host "Step 7: Setting up Elastic IP..." -ForegroundColor Yellow
try {
    $eips = aws ec2 describe-addresses --filters "Name=tag:Name,Values=cip-platform-ip" --region $REGION | ConvertFrom-Json
    if ($eips.Addresses.Count -gt 0) {
        $elasticIp = $eips.Addresses[0].PublicIp
        $allocationId = $eips.Addresses[0].AllocationId
        Write-Host "Elastic IP exists: $elasticIp" -ForegroundColor Green
        
        if (-not $eips.Addresses[0].InstanceId) {
            aws ec2 associate-address --instance-id $instanceId --allocation-id $allocationId --region $REGION | Out-Null
            Write-Host "Elastic IP associated" -ForegroundColor Green
        }
    } else {
        throw
    }
} catch {
    $allocation = aws ec2 allocate-address --domain vpc --region $REGION | ConvertFrom-Json
    $elasticIp = $allocation.PublicIp
    $allocationId = $allocation.AllocationId
    
    aws ec2 create-tags --resources $allocationId --tags "Key=Name,Value=cip-platform-ip" --region $REGION | Out-Null
    aws ec2 associate-address --instance-id $instanceId --allocation-id $allocationId --region $REGION | Out-Null
    
    Write-Host "Elastic IP allocated: $elasticIp" -ForegroundColor Green
}
Write-Host ""

# Step 8: Wait for instance
Write-Host "Step 8: Waiting for instance to be ready..." -ForegroundColor Yellow
aws ec2 wait instance-status-ok --instance-ids $instanceId --region $REGION
Write-Host "Instance is ready!" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host "AWS Infrastructure Created!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Instance ID: $instanceId" -ForegroundColor White
Write-Host "Elastic IP: $elasticIp" -ForegroundColor White
Write-Host "Database: $dbEndpoint" -ForegroundColor White
Write-Host ""
Write-Host "Estimated Cost: ~52 USD/month" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Connect: ssh -i $KEY_NAME.pem ubuntu@$elasticIp" -ForegroundColor Gray
Write-Host "2. Deploy app on EC2" -ForegroundColor Gray
Write-Host ""

@{
    InstanceId = $instanceId
    ElasticIP = $elasticIp
    DBEndpoint = $dbEndpoint
    DBPassword = $DB_PASSWORD
    Region = $REGION
    KeyName = $KEY_NAME
} | ConvertTo-Json | Out-File -FilePath "deployment-info.json"

Write-Host "Info saved to: deployment-info.json" -ForegroundColor Green
