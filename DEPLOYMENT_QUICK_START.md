# ⚡ CIP Platform - Quick Start Deployment

## 🎯 You're 80% Done! Just 3 Steps Left (30 Minutes)

---

## Step 1: Create EC2 Instance (5 min)

### Go to: https://console.aws.amazon.com/ec2/

### Click "Launch Instance" and configure:

```
Name: cip-platform
AMI: Ubuntu Server 22.04 LTS (ami-0e2c8caa4b6378d8c)
Instance Type: t3.medium
Key Pair: cip-platform-key (select existing)
VPC: vpc-0a1e0224d8b2b9aaf
Security Group: sg-0b2e86f405b566eaf (select existing)
Storage: 30 GB gp3
```

### Click "Launch Instance"

### Copy the Instance ID (e.g., `i-0123456789abcdef0`)

---

## Step 2: Complete AWS Setup (2 min)

### Run in PowerShell:

```powershell
.\complete-deployment.ps1
```

### Enter your Instance ID when prompted

---

## Step 3: Deploy Application (20 min)

### Connect to EC2:

```powershell
ssh -i cip-platform-key.pem ubuntu@54.237.243.98
```

### On EC2, run:

```bash
wget https://raw.githubusercontent.com/abhaysahu-cse/career-intelligence-platform-light/main/deploy-aws.sh
chmod +x deploy-aws.sh
./deploy-aws.sh
```

### When prompted, enter:

```
RDS Endpoint: cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com
RDS Password: urh7plPnibkSfFAM
Elastic IP: 54.237.243.98
Gemini API Key: AIzaSyB0dzGSDGFEFJQ8aZkoYLzqwhvTKbuTcVc
Gmail: growingabhay05@gmail.com
Gmail Password: ozkswwmdrfxxfkcg
```

---

## 🎉 Access Your Platform

**Frontend:** http://54.237.243.98  
**Backend:** http://54.237.243.98:8080/actuator/health  
**ML Service:** http://54.237.243.98:8000/health

---

## 💰 Cost: ~$51/month

---

## 🆘 Troubleshooting

**SSH fails?** Wait 2-3 minutes after instance shows "Running"

**Service down?** Run on EC2:
```bash
pm2 status
pm2 logs
pm2 restart all
```

---

## 📚 Full Guide: `START_HERE_DEPLOYMENT.md`

---

**Let's deploy! 🚀**
