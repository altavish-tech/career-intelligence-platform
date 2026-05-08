# Complete AWS Deployment After EC2 Creation
# Run this after you create the EC2 instance via AWS Console

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Green
Write-Host "Complete CIP Platform Deployment" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Get Instance ID
Write-Host "Step 1: Enter Instance ID" -ForegroundColor Yellow
Write-Host "  (You can find this in EC2 Console after creating the instance)" -ForegroundColor Gray
$instanceId = Read-Host "Enter Instance ID (e.g., i-0123456789abcdef0)"

if (-not $instanceId) {
    Write-Host "Error: Instance ID is required!" -ForegroundColor Red
    exit 1
}

Write-Host "  Using Instance ID: $instanceId" -ForegroundColor Green
Write-Host ""

# Associate Elastic IP
Write-Host "Step 2: Associating Elastic IP..." -ForegroundColor Yellow
$allocationId = "eipalloc-05b248f46e9027e53"
try {
    aws ec2 associate-address `
        --instance-id $instanceId `
        --allocation-id $allocationId `
        --region us-east-1 | Out-Null
    
    Write-Host "  Elastic IP 54.237.243.98 associated successfully!" -ForegroundColor Green
} catch {
    Write-Host "  Warning: Could not associate Elastic IP. It might already be associated." -ForegroundColor Yellow
}
Write-Host ""

# Wait for instance to be ready
Write-Host "Step 3: Waiting for instance to be ready..." -ForegroundColor Yellow
Write-Host "  This may take 2-3 minutes..." -ForegroundColor Gray

try {
    aws ec2 wait instance-status-ok `
        --instance-ids $instanceId `
        --region us-east-1
    
    Write-Host "  Instance is ready!" -ForegroundColor Green
} catch {
    Write-Host "  Warning: Wait timed out, but instance might still be ready." -ForegroundColor Yellow
}
Write-Host ""

# Test SSH connection
Write-Host "Step 4: Testing SSH connection..." -ForegroundColor Yellow
Write-Host "  Trying to connect to 54.237.243.98..." -ForegroundColor Gray

$sshTest = "ssh -i cip-platform-key.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@54.237.243.98 'echo Connected' 2>&1"
$result = Invoke-Expression $sshTest

if ($result -like "*Connected*") {
    Write-Host "  SSH connection successful!" -ForegroundColor Green
} else {
    Write-Host "  SSH connection not ready yet. Wait 1-2 minutes and try again." -ForegroundColor Yellow
}
Write-Host ""

# Display deployment instructions
Write-Host "========================================" -ForegroundColor Green
Write-Host "EC2 Instance Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Connect to EC2:" -ForegroundColor Yellow
Write-Host "   ssh -i cip-platform-key.pem ubuntu@54.237.243.98" -ForegroundColor White
Write-Host ""

Write-Host "2. On the EC2 instance, run these commands:" -ForegroundColor Yellow
Write-Host "   wget https://raw.githubusercontent.com/abhaysahu-cse/career-intelligence-platform-light/main/deploy-aws.sh" -ForegroundColor White
Write-Host "   chmod +x deploy-aws.sh" -ForegroundColor White
Write-Host "   ./deploy-aws.sh" -ForegroundColor White
Write-Host ""

Write-Host "3. When prompted, provide:" -ForegroundColor Yellow
Write-Host "   RDS Endpoint: cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com" -ForegroundColor White
Write-Host "   RDS Password: [Check db-credentials.json]" -ForegroundColor White
Write-Host "   Elastic IP: 54.237.243.98" -ForegroundColor White
Write-Host "   Gemini API Key: AIzaSyB0dzGSDGFEFJQ8aZkoYLzqwhvTKbuTcVc" -ForegroundColor White
Write-Host "   Gmail: growingabhay05@gmail.com" -ForegroundColor White
Write-Host "   Gmail Password: ozkswwmdrfxxfkcg" -ForegroundColor White
Write-Host ""

Write-Host "4. After deployment (15-20 minutes), access your platform:" -ForegroundColor Yellow
Write-Host "   Frontend: http://54.237.243.98" -ForegroundColor White
Write-Host "   Backend: http://54.237.243.98:8080/actuator/health" -ForegroundColor White
Write-Host "   ML Service: http://54.237.243.98:8000/health" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "Ready to deploy application!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Save instance info
$deploymentInfo = @{
    InstanceId = $instanceId
    ElasticIP = "54.237.243.98"
    DBEndpoint = "cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com"
    Region = "us-east-1"
    KeyName = "cip-platform-key"
    DeploymentDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

$deploymentInfo | ConvertTo-Json | Out-File -FilePath "deployment-complete.json"
Write-Host "Deployment info saved to: deployment-complete.json" -ForegroundColor Green
Write-Host ""
