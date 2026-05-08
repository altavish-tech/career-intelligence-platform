# 🚀 CIP Platform - AWS Deployment Guide

## ⚡ Quick Start - Deploy in 30 Minutes

Your AWS infrastructure is **80% ready**! Just follow these 3 simple steps.

---

## 📊 Current Status

### ✅ Already Completed (You're 80% Done!)

| Component | Status | Details |
|-----------|--------|---------|
| **AWS Permissions** | ✅ Ready | EC2, RDS, VPC access configured |
| **SSH Key Pair** | ✅ Created | `cip-platform-key.pem` saved locally |
| **Security Groups** | ✅ Created | Ports configured for all services |
| **PostgreSQL Database** | ✅ Running | RDS instance ready and waiting |
| **Elastic IP** | ✅ Allocated | `54.237.243.98` reserved |

### ⏳ What's Left (20% - Just 30 Minutes!)

1. ⏳ Create EC2 instance (5 minutes)
2. ⏳ Associate Elastic IP (2 minutes)
3. ⏳ Deploy application (20 minutes)

---

## 🎯 3-Step Deployment Process

### **Step 1: Create EC2 Instance** (5 minutes)

#### Open AWS EC2 Console
Go to: https://console.aws.amazon.com/ec2/

#### Click "Launch Instance"

#### Configure Instance Settings:

**1. Name and Tags**
```
Name: cip-platform
```

**2. Application and OS Images (AMI)**
```
Quick Start: Ubuntu
AMI: Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
AMI ID: ami-0e2c8caa4b6378d8c
Architecture: 64-bit (x86)
```

**3. Instance Type**
```
Instance type: t3.medium
vCPUs: 2
Memory: 4 GiB
```

**4. Key Pair (login)**
```
Key pair name: cip-platform-key
✅ Select existing key pair (already created)
```

**5. Network Settings**
```
VPC: vpc-0a1e0224d8b2b9aaf (default)
Subnet: No preference (default subnet)
Auto-assign public IP: Enable

Firewall (security groups):
○ Select existing security group
☑ sg-0b2e86f405b566eaf (cip-ec2-sg)
```

**6. Configure Storage**
```
Volume 1 (Root volume):
- Size: 30 GiB
- Volume type: gp3
- Delete on termination: Yes
```

**7. Advanced Details**
```
Leave all defaults
```

#### Launch Instance
1. Click **"Launch instance"** button (orange button at bottom)
2. Wait for "Success" message
3. Click **"View all instances"**
4. Wait until **Instance State** shows "Running" (2-3 minutes)
5. **Copy the Instance ID** (looks like: `i-0123456789abcdef0`)

---

### **Step 2: Complete AWS Setup** (2 minutes)

Open PowerShell in your project directory and run:

```powershell
.\complete-deployment.ps1
```

When prompted, paste your **Instance ID** from Step 1.

**What this script does:**
- ✅ Associates Elastic IP `54.237.243.98` to your EC2 instance
- ✅ Waits for instance to be fully ready
- ✅ Tests SSH connection
- ✅ Displays deployment instructions

**Expected output:**
```
✅ Elastic IP 54.237.243.98 associated successfully!
✅ Instance is ready!
✅ SSH connection successful!
```

---

### **Step 3: Deploy Application** (20 minutes)

#### Connect to EC2 Instance

In PowerShell:
```powershell
ssh -i cip-platform-key.pem ubuntu@54.237.243.98
```

If you get a "Host key verification" prompt, type `yes` and press Enter.

#### Download and Run Deployment Script

On the EC2 instance, run these commands:

```bash
# Download deployment script
wget https://raw.githubusercontent.com/abhaysahu-cse/career-intelligence-platform-light/main/deploy-aws.sh

# Make it executable
chmod +x deploy-aws.sh

# Run deployment
./deploy-aws.sh
```

#### Provide Configuration When Prompted

The script will ask for these values. **Copy-paste them exactly:**

```
Enter RDS Endpoint: cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com

Enter RDS Password: urh7plPnibkSfFAM

Enter Your Elastic IP: 54.237.243.98

Enter Gemini API Key: AIzaSyB0dzGSDGFEFJQ8aZkoYLzqwhvTKbuTcVc

Enter Gmail Email: growingabhay05@gmail.com

Enter Gmail App Password: ozkswwmdrfxxfkcg
```

#### Wait for Deployment to Complete

The script will:
1. ✅ Update system packages (2 min)
2. ✅ Install Java, Node.js, Python (5 min)
3. ✅ Clone repository (1 min)
4. ✅ Build and deploy backend (5 min)
5. ✅ Deploy ML service (3 min)
6. ✅ Build and deploy frontend (4 min)
7. ✅ Configure Nginx (1 min)

**Total time: ~20 minutes**

You'll see progress messages like:
```
✅ System updated!
✅ Java installed!
✅ Backend deployed!
✅ ML Service deployed!
✅ Frontend deployed!
🎉 Deployment Complete!
```

---

## 🎉 Access Your Platform

After deployment completes, your platform will be live at:

### **Frontend (Main Application)**
```
http://54.237.243.98
```
Open this in your browser to use the platform!

### **Backend API Health Check**
```
http://54.237.243.98:8080/actuator/health
```
Should return: `{"status":"UP"}`

### **ML Service Health Check**
```
http://54.237.243.98:8000/health
```
Should return: `{"status":"healthy"}`

---

## ✅ Verify Deployment

### Test the Platform

1. **Open Frontend:** http://54.237.243.98
2. **Create Account:** Click "Sign Up" and register
3. **Login:** Use your credentials
4. **Test Chatbot:** Go to Dashboard → Ask the AI assistant a question
5. **Upload Resume:** Go to Profile → Upload your resume
6. **Upload Certificate:** Go to Certificates → Upload a certificate

### Check Service Status

SSH into EC2 and run:
```bash
pm2 status
```

You should see:
```
┌─────┬──────────────────┬─────────┬─────────┐
│ id  │ name             │ status  │ restart │
├─────┼──────────────────┼─────────┼─────────┤
│ 0   │ cip-backend      │ online  │ 0       │
│ 1   │ cip-ml           │ online  │ 0       │
│ 2   │ cip-frontend     │ online  │ 0       │
└─────┴──────────────────┴─────────┴─────────┘
```

All services should show **"online"** status.

---

## 💰 Monthly Cost Breakdown

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| EC2 Instance | t3.medium (2 vCPU, 4 GB RAM) | $30.37 |
| EC2 Storage | 30 GB gp3 SSD | $2.40 |
| RDS Database | db.t3.micro PostgreSQL | $12.41 |
| RDS Storage | 20 GB | $2.30 |
| Elastic IP | 1 IP address | $3.60 |
| **TOTAL** | | **~$51/month** |

**Note:** Actual costs may vary slightly based on:
- Data transfer (usually minimal for demo/hackathon)
- Backup storage (1 day retention included)
- Region pricing differences

---

## 🛠️ Useful Commands

### On Your Local Machine

**Check AWS Resources:**
```powershell
# View EC2 instances
aws ec2 describe-instances --region us-east-1

# View RDS databases
aws rds describe-db-instances --region us-east-1

# View Elastic IPs
aws ec2 describe-addresses --region us-east-1
```

**Connect to EC2:**
```powershell
ssh -i cip-platform-key.pem ubuntu@54.237.243.98
```

### On EC2 Instance

**View Service Status:**
```bash
pm2 status
```

**View Logs:**
```bash
# All services
pm2 logs

# Specific service
pm2 logs cip-backend
pm2 logs cip-ml
pm2 logs cip-frontend
```

**Restart Services:**
```bash
# Restart all
pm2 restart all

# Restart specific service
pm2 restart cip-backend
pm2 restart cip-ml
pm2 restart cip-frontend
```

**Stop Services:**
```bash
pm2 stop all
```

**Monitor Resources:**
```bash
pm2 monit
```

**Check Nginx:**
```bash
sudo systemctl status nginx
sudo nginx -t  # Test configuration
```

**View System Resources:**
```bash
htop  # Interactive process viewer
df -h  # Disk usage
free -h  # Memory usage
```

---

## 🔧 Troubleshooting

### EC2 Instance Won't Start

**Problem:** Instance state stuck at "pending"

**Solution:**
1. Wait 2-3 minutes
2. Check AWS Service Health Dashboard
3. Try stopping and starting the instance

### SSH Connection Fails

**Problem:** `Connection refused` or `Connection timed out`

**Solutions:**
1. **Wait 2-3 minutes** after instance shows "Running"
2. Verify Elastic IP is associated:
   ```powershell
   aws ec2 describe-addresses --region us-east-1
   ```
3. Check security group allows port 22:
   ```powershell
   aws ec2 describe-security-groups --group-ids sg-0b2e86f405b566eaf --region us-east-1
   ```
4. Verify key file permissions (on Linux/Mac):
   ```bash
   chmod 400 cip-platform-key.pem
   ```

### Deployment Script Fails

**Problem:** Script exits with error during deployment

**Solutions:**

1. **Check internet connectivity:**
   ```bash
   ping -c 3 google.com
   ```

2. **Check disk space:**
   ```bash
   df -h
   ```
   Should have at least 10 GB free.

3. **Check memory:**
   ```bash
   free -h
   ```

4. **Re-run the script:**
   ```bash
   ./deploy-aws.sh
   ```

5. **Check specific service logs:**
   ```bash
   pm2 logs cip-backend --lines 50
   ```

### Backend Won't Start

**Problem:** Backend shows "errored" in pm2 status

**Solutions:**

1. **Check logs:**
   ```bash
   pm2 logs cip-backend --lines 100
   ```

2. **Verify database connection:**
   ```bash
   psql -h cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com -U postgres -d cip_db
   ```
   Password: `urh7plPnibkSfFAM`

3. **Check Java version:**
   ```bash
   java -version
   ```
   Should be Java 17.

4. **Restart backend:**
   ```bash
   pm2 restart cip-backend
   ```

### Frontend Won't Load

**Problem:** Browser shows "Connection refused" or blank page

**Solutions:**

1. **Check frontend logs:**
   ```bash
   pm2 logs cip-frontend --lines 50
   ```

2. **Verify frontend is running:**
   ```bash
   curl http://localhost:3000
   ```

3. **Check Nginx:**
   ```bash
   sudo systemctl status nginx
   sudo nginx -t
   ```

4. **Restart Nginx:**
   ```bash
   sudo systemctl restart nginx
   ```

5. **Restart frontend:**
   ```bash
   pm2 restart cip-frontend
   ```

### ML Service Won't Start

**Problem:** ML service shows "errored" in pm2 status

**Solutions:**

1. **Check logs:**
   ```bash
   pm2 logs cip-ml --lines 100
   ```

2. **Verify Python environment:**
   ```bash
   cd /home/ubuntu/apps/career-intelligence-platform-light/cip-ml
   source venv/bin/activate
   python --version
   ```

3. **Check dependencies:**
   ```bash
   pip list
   ```

4. **Restart ML service:**
   ```bash
   pm2 restart cip-ml
   ```

### Database Connection Issues

**Problem:** Services can't connect to database

**Solutions:**

1. **Verify RDS is running:**
   ```powershell
   aws rds describe-db-instances --db-instance-identifier cip-database --region us-east-1
   ```
   Status should be "available".

2. **Check security group:**
   - RDS security group should allow port 5432 from EC2 security group

3. **Test connection from EC2:**
   ```bash
   psql -h cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com -U postgres -d cip_db
   ```

4. **Verify credentials in .env files:**
   ```bash
   cat /home/ubuntu/apps/career-intelligence-platform-light/cip-backend-lite/.env
   cat /home/ubuntu/apps/career-intelligence-platform-light/cip-ml/.env
   ```

---

## 📁 Important Files

### Local Files (Keep These Secure!)

| File | Purpose | Location |
|------|---------|----------|
| `cip-platform-key.pem` | SSH private key | Current directory |
| `db-credentials.json` | Database password | Current directory |
| `deployment-info.json` | Deployment details | Current directory |

⚠️ **IMPORTANT:** 
- Never commit these files to Git
- Keep backups in a secure location
- Don't share these files publicly

### Configuration Files on EC2

| File | Purpose | Location |
|------|---------|----------|
| Backend .env | Backend configuration | `/home/ubuntu/apps/career-intelligence-platform-light/cip-backend-lite/.env` |
| ML .env | ML service configuration | `/home/ubuntu/apps/career-intelligence-platform-light/cip-ml/.env` |
| Frontend .env.local | Frontend configuration | `/home/ubuntu/apps/career-intelligence-platform-light/cip-web/.env.local` |

---

## 🔒 Security Best Practices

### After Deployment

1. **Change Database Password:**
   ```sql
   ALTER USER postgres WITH PASSWORD 'new_secure_password';
   ```
   Then update .env files and restart services.

2. **Setup SSL/HTTPS:**
   - Get a domain name
   - Use Let's Encrypt for free SSL certificate
   - Configure Nginx for HTTPS

3. **Enable AWS CloudWatch:**
   - Monitor EC2 metrics
   - Set up alarms for high CPU/memory
   - Track RDS performance

4. **Regular Backups:**
   - RDS automated backups are enabled (1 day retention)
   - Consider increasing retention period
   - Test restore procedures

5. **Update Security Groups:**
   - Restrict SSH (port 22) to your IP only
   - Consider using AWS Systems Manager Session Manager instead of SSH

---

## 📊 Monitoring and Maintenance

### Daily Checks

```bash
# SSH into EC2
ssh -i cip-platform-key.pem ubuntu@54.237.243.98

# Check service status
pm2 status

# Check system resources
htop

# Check disk space
df -h
```

### Weekly Maintenance

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Restart services
pm2 restart all

# Check logs for errors
pm2 logs --lines 100
```

### Monthly Tasks

1. Review AWS billing dashboard
2. Check RDS backup retention
3. Review CloudWatch metrics
4. Update application dependencies
5. Test disaster recovery procedures

---

## 🚀 Scaling Options

### When You Need More Performance

**Option 1: Upgrade EC2 Instance**
```
Current: t3.medium (2 vCPU, 4 GB RAM) - $30/month
Upgrade: t3.large (2 vCPU, 8 GB RAM) - $60/month
Upgrade: t3.xlarge (4 vCPU, 16 GB RAM) - $121/month
```

**Option 2: Upgrade RDS Instance**
```
Current: db.t3.micro (1 vCPU, 1 GB RAM) - $12/month
Upgrade: db.t3.small (1 vCPU, 2 GB RAM) - $25/month
Upgrade: db.t3.medium (2 vCPU, 4 GB RAM) - $50/month
```

**Option 3: Add Load Balancer**
- Deploy multiple EC2 instances
- Use Application Load Balancer
- Auto-scaling based on traffic

**Option 4: Use AWS Elastic Beanstalk**
- Managed deployment
- Auto-scaling
- Load balancing
- Health monitoring

---

## 📚 Additional Resources

### AWS Documentation
- [EC2 User Guide](https://docs.aws.amazon.com/ec2/)
- [RDS User Guide](https://docs.aws.amazon.com/rds/)
- [VPC User Guide](https://docs.aws.amazon.com/vpc/)

### Project Documentation
- `AWS_DEPLOYMENT_GUIDE.md` - Detailed deployment guide
- `DEPLOYMENT_STATUS.md` - Current deployment status
- `PRODUCTION_RELEASE_SUMMARY.md` - Complete system overview
- `ARCHITECTURE.md` - System architecture

### Support
- **AWS Support:** https://console.aws.amazon.com/support/
- **GitHub Issues:** https://github.com/abhaysahu-cse/career-intelligence-platform-light/issues

---

## ✅ Deployment Checklist

### Pre-Deployment
- [x] AWS account created
- [x] AWS CLI configured
- [x] Permissions added (EC2, RDS, VPC)
- [x] SSH key pair created
- [x] Security groups created
- [x] RDS database created
- [x] Elastic IP allocated

### Deployment
- [ ] EC2 instance created via console
- [ ] Instance ID copied
- [ ] `complete-deployment.ps1` executed
- [ ] Elastic IP associated
- [ ] SSH connection successful
- [ ] `deploy-aws.sh` downloaded on EC2
- [ ] Deployment script executed
- [ ] All configuration provided
- [ ] Deployment completed successfully

### Post-Deployment
- [ ] Frontend accessible at http://54.237.243.98
- [ ] Backend health check returns OK
- [ ] ML service health check returns OK
- [ ] Can create account
- [ ] Can login
- [ ] Chatbot responds
- [ ] Can upload resume
- [ ] Can upload certificate
- [ ] All PM2 services online

### Security
- [ ] Backed up `cip-platform-key.pem`
- [ ] Backed up `db-credentials.json`
- [ ] Reviewed security group rules
- [ ] Planned SSL/HTTPS setup
- [ ] Set up monitoring alerts

---

## 🎯 Success Criteria

Your deployment is successful when:

✅ EC2 instance shows "Running" in AWS console  
✅ Elastic IP `54.237.243.98` is associated  
✅ SSH connection works  
✅ All 3 PM2 services show "online"  
✅ Frontend loads at http://54.237.243.98  
✅ Backend health check returns `{"status":"UP"}`  
✅ ML service health check returns `{"status":"healthy"}`  
✅ Can create account and login  
✅ Chatbot responds to messages  
✅ Can upload and analyze resumes  
✅ Can upload and validate certificates  

---

## 🎉 You're Ready to Deploy!

**Current Status:** 80% Complete  
**Time Remaining:** 30 minutes  
**Next Step:** Create EC2 instance via AWS Console

**Let's finish this deployment!** 💪

---

## 📞 Quick Links

- **EC2 Console:** https://console.aws.amazon.com/ec2/
- **RDS Console:** https://console.aws.amazon.com/rds/
- **Your Database:** cip-database.caro8qw6sxfx.us-east-1.rds.amazonaws.com
- **Your Elastic IP:** 54.237.243.98
- **GitHub Repo:** https://github.com/abhaysahu-cse/career-intelligence-platform-light

---

**Good luck with your deployment! 🚀**
