# 🖥️ Create EC2 Instance via AWS Console

## Quick Guide (5 minutes)

Since the CLI is having issues, let's create the EC2 instance through the AWS Console.

---

## 📋 Step-by-Step Instructions

### **Step 1: Open EC2 Console**

1. Go to: **https://console.aws.amazon.com/ec2/**
2. Make sure you're in **US East (N. Virginia)** region (top right corner)
3. Click **Launch Instance** (orange button)

---

### **Step 2: Name and Tags**

```
Name: cip-platform
```

---

### **Step 3: Application and OS Images (AMI)**

1. Select: **Ubuntu**
2. Choose: **Ubuntu Server 22.04 LTS (HVM), SSD Volume Type**
3. Architecture: **64-bit (x86)**
4. AMI ID should be: `ami-0e2c8caa4b6378d8c`

---

### **Step 4: Instance Type**

1. Select: **t3.medium**
   - 2 vCPU
   - 4 GiB Memory
   - Cost: ~$0.0416/hour (~$30/month)

**Note:** This is NOT free tier, but required for the application to run properly.

---

### **Step 5: Key Pair (login)**

1. **Select existing key pair**
2. Choose: **cip-platform-key**
3. Check the acknowledgment box

---

### **Step 6: Network Settings**

Click **Edit** and configure:

1. **VPC:** Select `vpc-0a1e0224d8b2b9aaf` (your default VPC)

2. **Subnet:** No preference (default)

3. **Auto-assign public IP:** Enable

4. **Firewall (security groups):**
   - Select: **Select existing security group**
   - Choose: **sg-0b2e86f405b566eaf** (cip-ec2-sg)

---

### **Step 7: Configure Storage**

1. **Size:** `30` GiB
2. **Volume Type:** `gp3`
3. **Delete on termination:** Checked (default)

---

### **Step 8: Advanced Details**

Leave all as default (no changes needed)

---

### **Step 9: Summary**

Review your configuration:
- Name: cip-platform
- AMI: Ubuntu 22.04 LTS
- Instance type: t3.medium
- Key pair: cip-platform-key
- Security group: sg-0b2e86f405b566eaf
- Storage: 30 GB gp3

---

### **Step 10: Launch**

1. Click **Launch Instance** (orange button)
2. You'll see: "Successfully initiated launch of instance"
3. Click **View all instances**
4. Wait for **Instance State** to show **Running** (1-2 minutes)
5. **Copy the Instance ID** (e.g., `i-0123456789abcdef0`)

---

## ✅ After Instance is Running

### **Step 1: Associate Elastic IP**

Run this in PowerShell (replace `INSTANCE_ID` with your actual instance ID):

```powershell
# Replace INSTANCE_ID with your instance ID
$instanceId = "INSTANCE_ID"

aws ec2 associate-address `
  --instance-id $instanceId `
  --public-ip 54.237.243.98 `
  --region us-east-1

Write-Host "Elastic IP associated!" -ForegroundColor Green
```

### **Step 2: Wait for Instance to be Ready**

```powershell
Write-Host "Waiting for instance to be ready..." -ForegroundColor Yellow

aws ec2 wait instance-status-ok `
  --instance-ids $instanceId `
  --region us-east-1

Write-Host "Instance is ready!" -ForegroundColor Green
```

### **Step 3: Test SSH Connection**

```powershell
# Test connection
ssh -i cip-platform-key.pem ubuntu@54.237.243.98
```

If you get a connection, type `exit` to disconnect.

---

## 🚀 Deploy Application

### **Step 1: Connect to EC2**

```powershell
ssh -i cip-platform-key.pem ubuntu@54.237.243.98
```

### **Step 2: Download Deployment Script**

```bash
# Download script
wget https://raw.githubusercontent.com/abhaysahu-cse/career-intelligence-platform-light/main/deploy-aws.sh

# Make executable
chmod +x deploy-aws.sh

# Run deployment
./deploy-aws.sh
```

### **Step 3: Provide Configuration**

When prompted, enter:

```
RDS Endpoint: cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com
RDS Password: [Check db-credentials.json file]
Elastic IP: 54.237.243.98
Gemini API Key: AIzaSyB0dzGSDGFEFJQ8aZkoYLzqwhvTKbuTcVc
Gmail Email: growingabhay05@gmail.com
Gmail Password: ozkswwmdrfxxfkcg
```

### **Step 4: Wait for Deployment**

The script will:
- Install Java, Node.js, Python (5 min)
- Clone repository (1 min)
- Build backend (3 min)
- Deploy ML service (2 min)
- Build frontend (5 min)
- Configure Nginx (1 min)

**Total time: ~15-20 minutes**

---

## 🎉 Access Your Platform

Once deployment completes:

- **Frontend:** http://54.237.243.98
- **Backend API:** http://54.237.243.98:8080/actuator/health
- **ML Service:** http://54.237.243.98:8000/health

---

## 💰 Final Cost Breakdown

| Resource | Monthly Cost |
|----------|--------------|
| EC2 t3.medium | $30.37 |
| RDS db.t3.micro | $12.41 |
| Storage (50 GB) | $4.70 |
| Elastic IP | $3.60 |
| Data Transfer | $0.90 |
| **TOTAL** | **~$52/month** |

---

## 🔧 Troubleshooting

### **Can't find security group?**
- Make sure you're in **us-east-1** region
- Security group ID: `sg-0b2e86f405b566eaf`

### **Can't find key pair?**
- Make sure you're in **us-east-1** region
- Key pair name: `cip-platform-key`

### **Instance won't start?**
- Check if you have EC2 service limits
- Try t3.small instead of t3.medium

### **SSH connection refused?**
- Wait 2-3 minutes after instance shows "Running"
- Make sure Elastic IP is associated
- Check security group allows port 22

---

## 📝 Quick Reference

**Your Resources:**
- VPC: `vpc-0a1e0224d8b2b9aaf`
- Security Group: `sg-0b2e86f405b566eaf`
- Key Pair: `cip-platform-key`
- Elastic IP: `54.237.243.98`
- Database: `cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com`

**Files You Have:**
- `cip-platform-key.pem` - SSH key
- `db-credentials.json` - Database password
- `deployment-info.json` - All details

---

## ✅ Checklist

- [ ] Opened EC2 Console
- [ ] Launched instance with correct settings
- [ ] Instance is running
- [ ] Copied Instance ID
- [ ] Associated Elastic IP
- [ ] Tested SSH connection
- [ ] Ran deployment script on EC2
- [ ] Application deployed successfully
- [ ] Can access frontend at http://54.237.243.98

---

**Once the EC2 instance is created, you're just 20 minutes away from having your platform live!** 🚀
