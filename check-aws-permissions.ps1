# AWS Permissions Verification Script

Write-Host "Checking AWS Permissions..." -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Test EC2 permissions
Write-Host "Testing EC2 permissions..." -ForegroundColor Yellow
try {
    aws ec2 describe-instances --region us-east-1 --max-items 1 2>$null | Out-Null
    Write-Host "  EC2: OK" -ForegroundColor Green
} catch {
    Write-Host "  EC2: FAILED - Need AmazonEC2FullAccess" -ForegroundColor Red
    $allGood = $false
}

# Test RDS permissions
Write-Host "Testing RDS permissions..." -ForegroundColor Yellow
try {
    aws rds describe-db-instances --region us-east-1 --max-records 1 2>$null | Out-Null
    Write-Host "  RDS: OK" -ForegroundColor Green
} catch {
    Write-Host "  RDS: FAILED - Need AmazonRDSFullAccess" -ForegroundColor Red
    $allGood = $false
}

# Test VPC permissions
Write-Host "Testing VPC permissions..." -ForegroundColor Yellow
try {
    aws ec2 describe-vpcs --region us-east-1 --max-results 1 2>$null | Out-Null
    Write-Host "  VPC: OK" -ForegroundColor Green
} catch {
    Write-Host "  VPC: FAILED - Need AmazonVPCFullAccess" -ForegroundColor Red
    $allGood = $false
}

Write-Host ""

if ($allGood) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "All permissions are working!" -ForegroundColor Green
    Write-Host "You can now run: .\simple-aws-deploy.ps1" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Some permissions are missing!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please add these policies to your IAM user:" -ForegroundColor Yellow
    Write-Host "  1. AmazonEC2FullAccess" -ForegroundColor White
    Write-Host "  2. AmazonRDSFullAccess" -ForegroundColor White
    Write-Host "  3. AmazonVPCFullAccess" -ForegroundColor White
    Write-Host ""
    Write-Host "See AWS_PERMISSIONS_SETUP.md for detailed instructions" -ForegroundColor Cyan
}

Write-Host ""
