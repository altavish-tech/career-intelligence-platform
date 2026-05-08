# ⚡ Quick Deployment Reference Card

## 🎯 Your AWS Resources

```
Region: us-east-1 (N. Virginia)
VPC: vpc-0a1e0224d8b2b9aaf
Security Group: sg-0b2e86f405b566eaf
Key Pair: cip-platform-key
Elastic IP: 54.237.243.98
Allocation ID: eipalloc-05b248f46e9027e53
Database: cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com
```

---

## 📋 Quick Steps

### 1. Create EC2 (AWS Console)
```
https://console.aws.amazon.com/ec2/
→ Launch Instance
→ Name: cip-platform
→ AMI: Ubuntu 22.04 (ami-0e2c8caa4b6378d8c)
→ Type: t3.medium
→ Key: cip-platform-key
→ SG: sg-0b2e86f405b566eaf
→ Storage: 30 GB gp3
→ Launch
→ Copy Instance ID
```

### 2. Associate IP (PowerShell)
```powershell
$instanceId = "YOUR_INSTANCE_ID"

aws ec2 associate-address `
  --instance-id $instanceId `
  --allocation-id eipalloc-05b248f46e9027e53 `
  --region us-east-1
```

### 3. Wait for Ready
```powershell
aws ec2 wait instance-status-ok `
  --instance-ids $instanceId `
  --region us-east-1
```

### 4. Get DB Password
```powershell
$dbCreds = Get-Content db-credentials.json | ConvertFrom-Json
Write-Host $dbCreds.DBPassword
```

### 5. Deploy App (SSH)
```bash
ssh -i cip-platform-key.pem ubuntu@54.237.243.98

wget https://raw.githubusercontent.com/abhaysahu-cse/career-intelligence-platform-light/main/deploy-aws.sh
chmod +x deploy-aws.sh
./deploy-aws.sh
```

### 6. Provide Config
```
RDS Endpoint: cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com
RDS Password: [from step 4]
Elastic IP: 54.237.243.98
Gemini Key: AIzaSyB0dzGSDGFEFJQ8aZkoYLzqwhvTKbuTcVc
Gmail: growingabhay05@gmail.com
Gmail Pass: ozkswwmdrfxxfkcg
```

---

## 🌐 Access URLs

```
Frontend:   http://54.237.243.98
Backend:    http://54.237.243.98:8080/actuator/health
ML Service: http://54.237.243.98:8000/health
```

---

## 🔧 Useful Commands

```bash
# SSH
ssh -i cip-platform-key.pem ubuntu@54.237.243.98

# Check services
pm2 status

# View logs
pm2 logs cip-backend
pm2 logs cip-ml
pm2 logs cip-frontend

# Restart
pm2 restart all

# Monitor
pm2 monit
```

---

## 💰 Cost

**~$52/month**

---

## 📞 Help

See: `DEPLOY_STEP_BY_STEP.md`
