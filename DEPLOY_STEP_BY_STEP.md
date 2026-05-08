# 🚀 Complete AWS Deployment - Step by Step

## Overview

This guide will walk you through deploying the Career Intelligence Platform to AWS from start to finish.

**Total Time:** ~30 minutes  
**Total Cost:** ~$52/month

---

## ✅ Prerequisites (Already Done!)

- [x] AWS CLI configured
- [x] AWS permissions added
- [x] SSH key created: `cip-platform-key.pem`
- [x] Security groups created
- [x] PostgreSQL database created
- [x] Elastic IP allocated: `54.237.243.98`
- [x] Allocation ID: `eipalloc-05b248f46e9027e53`

---

## 📋 Step-by-Step Deployment

### **STEP 1: Create EC2 Instance via AWS Console** (5 minutes)

#### 1.1 Open EC2 Console
```
URL: https://console.aws.amazon.com/ec2/
```
- Make sure region is **US East (N. Virginia)** - us-east-1
- Click **"Launch Instance"** (orange button)

#### 1.2 Configure Instance

**Name and tags:**
```
Name: cip-platform
```

**Application and OS Images (AMI):**
```
- Select: Ubuntu
- Choose: Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
- Architecture: 64-bit (x86)
- AMI ID: ami-0e2c8caa4b6378d8c
```

**Instance type:**
```
- Type: t3.medium
- vCPUs: 2
- Memory: 4 GiB
- Note: This is NOT free tier (~$30/month)
```

**Key pair (login):**
```
- Select existing key pair
- Choose: cip-platform-key
- Check the acknowledgment box
```

**Network settings:**
```
Click "Edit" button:

VPC: vpc-0a1e0224d8b2b9aaf
Subnet: No preference (default)
Auto-assign public IP: Enable
Firewall (security groups):
  - Select: "Select existing security group"
  - Choose: sg-0b2e86f405b566eaf (cip-ec2-sg)
```

**Configure storage:**
```
Size: 30 GiB
Volume type: gp3
Delete on termination: Checked
```

**Advanced details:**
```
Leave all defaults (don't change anything)
```

#### 1.3 Launch Instance

1. Review summary on the right
2. Click **"Launch instance"** (orange button)
3. Wait for success message
4. Click **"View all instances"**
5. Wait for **Instance State** = **Running** (1-2 minutes)
6. Wait for **Status check** = **2/2 checks passed** (2-3 minutes)

#### 1.4 Copy Instance ID

1. Click on your instance in the list
2. Find **Instance ID** at the top (e.g., `i-0123456789abcdef0`)
3. **Copy this ID** - you'll need it next!

---

### **STEP 2: Associate Elastic IP** (1 minute)

Open PowerShell in your project directory and run:

```powershell
# Replace YOUR_INSTANCE_ID with the actual ID you copied
$instanceId = "YOUR_INSTANCE_ID"

# Associate Elastic IP
aws ec2 associate-address `
  --instance-id $instanceId `
  --allocation-id eipalloc-05b248f46e9027e53 `
  --region us-east-1

Write-Host "Elastic IP associated!" -ForegroundColor Green
```

**Expected output:**
```json
{
    "AssociationId": "eipassoc-xxxxx"
}
```

---

### **STEP 3: Wait for Instance to be Ready** (2 minutes)

```powershell
Write-Host "Waiting for instance to be ready..." -ForegroundColor Yellow

aws ec2 wait instance-status-ok `
  --instance-ids $instanceId `
  --region us-east-1

Write-Host "Instance is ready!" -ForegroundColor Green
```

This command will wait until the instance passes all status checks.

---

### **STEP 4: Test SSH Connection** (1 minute)

```powershell
# Test connection
ssh -i cip-platform-key.pem ubuntu@54.237.243.98
```

**Expected:**
- You should see Ubuntu welcome message
- Prompt changes to: `ubuntu@ip-xxx-xxx-xxx-xxx:~$`

**If connection works:**
```bash
# Type this to disconnect
exit
```

**If connection fails:**
- Wait 1-2 more minutes
- Try again
- Check that Elastic IP was associated correctly

---

### **STEP 5: Get Database Password** (30 seconds)

In PowerShell:

```powershell
# Read database credentials
$dbCreds = Get-Content db-credentials.json | ConvertFrom-Json
$dbPassword = $dbCreds.DBPassword

Write-Host "Database Password: $dbPassword" -ForegroundColor Cyan
Write-Host ""
Write-Host "Copy this password - you'll need it in the next step!" -ForegroundColor Yellow
```

**Copy the password that's displayed!**

---

### **STEP 6: Connect to EC2 and Deploy Application** (20 minutes)

#### 6.1 Connect to EC2

```powershell
ssh -i cip-platform-key.pem ubuntu@54.237.243.98
```

You're now on the EC2 instance!

#### 6.2 Download Deployment Script

```bash
# Download the deployment script
wget https://raw.githubusercontent.com/abhaysahu-cse/career-intelligence-platform-light/main/deploy-aws.sh

# Make it executable
chmod +x deploy-aws.sh
```

#### 6.3 Run Deployment Script

```bash
./deploy-aws.sh
```

#### 6.4 Provide Configuration

The script will ask for these values. Enter them exactly:

**1. RDS Endpoint:**
```
cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com
```

**2. RDS Password:**
```
[Paste the password you copied in Step 5]
```

**3. Elastic IP:**
```
54.237.243.98
```

**4. Gemini API Key:**
```
AIzaSyB0dzGSDGFEFJQ8aZkoYLzqwhvTKbuTcVc
```

**5. Gmail Email:**
```
growingabhay05@gmail.com
```

**6. Gmail App Password:**
```
ozkswwmdrfxxfkcg
```

#### 6.5 Wait for Deployment

The script will now:
- ✅ Update system packages (2 min)
- ✅ Install Java 17 (1 min)
- ✅ Install Node.js 18 (1 min)
- ✅ Install Python 3.11 (1 min)
- ✅ Install additional tools (1 min)
- ✅ Clone repository (1 min)
- ✅ Build backend (3 min)
- ✅ Deploy ML service (2 min)
- ✅ Build frontend (5 min)
- ✅ Configure Nginx (1 min)
- ✅ Setup PM2 auto-start (1 min)

**Total: ~20 minutes**

You'll see progress messages as each step completes.

#### 6.6 Verify Deployment

At the end, you should see:

```
============================================
🎉 Deployment Complete!
============================================

📊 Service URLs:
   Frontend:  http://54.237.243.98
   Backend:   http://54.237.243.98:8080/actuator/health
   ML Service: http://54.237.243.98:8000/health

✅ Backend is running!
✅ ML Service is running!
✅ Frontend is running!
```

---

### **STEP 7: Access Your Platform** (1 minute)

Open your browser and go to:

**Frontend:**
```
http://54.237.243.98
```

You should see the Career Intelligence Platform homepage!

**Test Backend:**
```
http://54.237.243.98:8080/actuator/health
```

Should return:
```json
{
  "status": "UP"
}
```

**Test ML Service:**
```
http://54.237.243.98:8000/health
```

Should return:
```json
{
  "status": "healthy"
}
```

---

## ✅ Deployment Complete!

### **What You Now Have:**

1. ✅ EC2 Instance running Ubuntu 22.04
2. ✅ PostgreSQL Database (RDS)
3. ✅ Backend API (Spring Boot)
4. ✅ ML Service (FastAPI)
5. ✅ Frontend (Next.js)
6. ✅ Nginx reverse proxy
7. ✅ PM2 process manager
8. ✅ Auto-restart on reboot

### **Your Platform URLs:**

- **Main App:** http://54.237.243.98
- **Backend API:** http://54.237.243.98:8080
- **ML Service:** http://54.237.243.98:8000

### **SSH Access:**

```powershell
ssh -i cip-platform-key.pem ubuntu@54.237.243.98
```

---

## 🔧 Useful Commands

### **On EC2 Instance:**

```bash
# Check all services
pm2 status

# View logs
pm2 logs cip-backend
pm2 logs cip-ml
pm2 logs cip-frontend

# Restart services
pm2 restart all

# Stop services
pm2 stop all

# Start services
pm2 start all

# Monitor resources
pm2 monit
```

---

## 💰 Monthly Cost Breakdown

| Resource | Cost |
|----------|------|
| EC2 t3.medium | $30.37 |
| RDS db.t3.micro | $12.41 |
| Storage (50 GB) | $4.70 |
| Elastic IP | $3.60 |
| Data Transfer | $0.90 |
| **TOTAL** | **~$52/month** |

---

## 🔄 Update Application

To update your application later:

```bash
# Connect to EC2
ssh -i cip-platform-key.pem ubuntu@54.237.243.98

# Navigate to project
cd /home/ubuntu/apps/career-intelligence-platform-light

# Pull latest code
git pull origin main
git submodule update --recursive

# Rebuild backend
cd cip-backend-lite
mvn clean package -DskipTests
pm2 restart cip-backend

# Rebuild frontend
cd ../cip-web
npm install
npm run build
pm2 restart cip-frontend

# Restart ML service
pm2 restart cip-ml
```

---

## 🆘 Troubleshooting

### **Frontend not loading:**
```bash
pm2 logs cip-frontend --lines 50
# Check if port 3000 is accessible
curl http://localhost:3000
```

### **Backend not responding:**
```bash
pm2 logs cip-backend --lines 50
# Check if backend is running
curl http://localhost:8080/actuator/health
```

### **ML Service not working:**
```bash
pm2 logs cip-ml --lines 50
# Check if ML service is running
curl http://localhost:8000/health
```

### **Database connection failed:**
```bash
# Test database connection
psql -h cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com -U postgres -d cip_db
# Enter password when prompted
```

### **Out of memory:**
```bash
# Check memory
free -h

# Add swap space
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

---

## 📊 Monitoring

### **Check System Resources:**
```bash
# CPU and Memory
htop

# Disk usage
df -h

# Network connections
netstat -tulpn
```

### **Check Service Status:**
```bash
# PM2 status
pm2 status

# Nginx status
sudo systemctl status nginx

# Check ports
sudo lsof -i :3000
sudo lsof -i :8080
sudo lsof -i :8000
```

---

## 🔒 Security Recommendations

1. **Change database password:**
   ```bash
   # In RDS console, modify DB instance
   # Change master password
   # Update application.yml with new password
   ```

2. **Setup SSL certificate (optional):**
   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d yourdomain.com
   ```

3. **Enable firewall:**
   ```bash
   sudo ufw allow 22
   sudo ufw allow 80
   sudo ufw allow 443
   sudo ufw enable
   ```

4. **Regular updates:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

---

## 📝 Important Files

| File | Location | Purpose |
|------|----------|---------|
| `cip-platform-key.pem` | Local | SSH private key |
| `db-credentials.json` | Local | Database password |
| `deployment-info.json` | Local | Deployment details |
| `application.yml` | EC2: `/home/ubuntu/apps/.../cip-backend-lite/src/main/resources/` | Backend config |
| `.env.local` | EC2: `/home/ubuntu/apps/.../cip-web/` | Frontend config |

---

## ✅ Final Checklist

- [ ] EC2 instance created and running
- [ ] Elastic IP associated
- [ ] SSH connection working
- [ ] Deployment script completed
- [ ] All services running (pm2 status)
- [ ] Frontend accessible at http://54.237.243.98
- [ ] Backend API responding
- [ ] ML service responding
- [ ] Can create account and login
- [ ] Chatbot working
- [ ] Interview system working
- [ ] Job search working
- [ ] Certificate validation working

---

## 🎉 Success!

Your Career Intelligence Platform is now live on AWS!

**Platform URL:** http://54.237.243.98

**Features Available:**
- ✅ AI-Powered Chatbot
- ✅ Mock Interviews
- ✅ Job Matching
- ✅ Certificate Validation
- ✅ Career Analytics
- ✅ Resume Parsing
- ✅ Automated Email Reports

**Next Steps:**
1. Test all features
2. Create a demo account
3. Try the chatbot
4. Run a mock interview
5. Upload a certificate
6. Search for jobs

---

**Congratulations on deploying your platform!** 🚀🎉
