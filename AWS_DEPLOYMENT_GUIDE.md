# 🚀 AWS Deployment Guide - Career Intelligence Platform

## 📋 Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Cost Estimation](#cost-estimation)
3. [Prerequisites](#prerequisites)
4. [Deployment Options](#deployment-options)
5. [Step-by-Step EC2 Deployment](#step-by-step-ec2-deployment)
6. [Database Setup (RDS)](#database-setup-rds)
7. [Domain & SSL Setup](#domain--ssl-setup)
8. [Monitoring & Maintenance](#monitoring--maintenance)

---

## 🏗️ Architecture Overview

### **Recommended AWS Architecture:**

```
┌─────────────────────────────────────────────────────────────┐
│                         Internet                             │
└────────────────────────┬────────────────────────────────────┘
                         │
                    ┌────▼────┐
                    │ Route 53│ (Domain DNS)
                    └────┬────┘
                         │
                    ┌────▼────┐
                    │   ALB   │ (Load Balancer)
                    └────┬────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
   ┌────▼────┐     ┌────▼────┐     ┌────▼────┐
   │  EC2-1  │     │  EC2-2  │     │  EC2-3  │
   │Frontend │     │Backend  │     │ML Service│
   │Port 3000│     │Port 8080│     │Port 8000│
   └─────────┘     └────┬────┘     └─────────┘
                        │
                   ┌────▼────┐
                   │   RDS   │ (PostgreSQL)
                   │Port 5432│
                   └─────────┘
```

---

## 💰 Cost Estimation

### **Option 1: Single EC2 Instance (Budget - Recommended for Demo)**

| Service | Specification | Monthly Cost (USD) |
|---------|--------------|-------------------|
| **EC2 Instance** | t3.medium (2 vCPU, 4GB RAM) | $30.37 |
| **EBS Storage** | 30 GB gp3 | $2.40 |
| **RDS PostgreSQL** | db.t3.micro (1 vCPU, 1GB RAM) | $12.41 |
| **RDS Storage** | 20 GB gp3 | $2.30 |
| **Elastic IP** | 1 Static IP | $3.60 |
| **Data Transfer** | 10 GB/month | $0.90 |
| **Route 53** | Hosted Zone + Queries | $0.50 |
| **SSL Certificate** | AWS Certificate Manager | FREE |
| **Total** | | **~$52/month** |

### **Option 2: Multi-Instance Setup (Production)**

| Service | Specification | Monthly Cost (USD) |
|---------|--------------|-------------------|
| **EC2 Frontend** | t3.small (2 vCPU, 2GB RAM) | $15.18 |
| **EC2 Backend** | t3.medium (2 vCPU, 4GB RAM) | $30.37 |
| **EC2 ML Service** | t3.medium (2 vCPU, 4GB RAM) | $30.37 |
| **EBS Storage** | 90 GB total (30GB × 3) | $7.20 |
| **RDS PostgreSQL** | db.t3.small (1 vCPU, 2GB RAM) | $24.82 |
| **RDS Storage** | 50 GB gp3 | $5.75 |
| **Application Load Balancer** | ALB | $16.20 |
| **Elastic IPs** | 3 Static IPs | $10.80 |
| **Data Transfer** | 50 GB/month | $4.50 |
| **Route 53** | Hosted Zone + Queries | $0.50 |
| **SSL Certificate** | AWS Certificate Manager | FREE |
| **Total** | | **~$145/month** |

### **Option 3: Serverless (Advanced - Future)**

| Service | Specification | Monthly Cost (USD) |
|---------|--------------|-------------------|
| **ECS Fargate** | 3 containers (0.5 vCPU, 1GB each) | $35-50 |
| **RDS Aurora Serverless** | PostgreSQL compatible | $40-60 |
| **S3** | File storage | $5-10 |
| **CloudFront** | CDN | $10-20 |
| **API Gateway** | REST API | $3-5 |
| **Total** | | **~$93-145/month** |

---

## 📋 Prerequisites

### **1. AWS Account Setup**
- Create AWS account: https://aws.amazon.com/
- Set up billing alerts
- Enable MFA for security

### **2. Local Requirements**
- AWS CLI installed
- SSH key pair generated
- Domain name (optional but recommended)

### **3. Required Information**
- GitHub repository access
- Gemini API key
- Gmail SMTP credentials
- Database password

---

## 🎯 Deployment Options

### **Recommended for You: Option 1 - Single EC2 Instance**

**Why?**
- ✅ Lowest cost (~$52/month)
- ✅ Easy to manage
- ✅ Perfect for demo/hackathon
- ✅ Can handle 100-500 concurrent users
- ✅ Simple deployment

**Limitations:**
- Single point of failure
- Limited scalability
- Manual scaling required

---

## 🚀 Step-by-Step EC2 Deployment

### **Step 1: Launch EC2 Instance**

1. **Login to AWS Console**
   - Go to: https://console.aws.amazon.com/
   - Navigate to EC2 Dashboard

2. **Launch Instance**
   ```
   Click "Launch Instance"
   
   Name: cip-platform-server
   
   AMI: Ubuntu Server 22.04 LTS (Free tier eligible)
   
   Instance Type: t3.medium
   - 2 vCPU
   - 4 GB RAM
   - $30.37/month
   
   Key Pair: Create new or use existing
   - Download .pem file
   - Save securely
   
   Network Settings:
   - Create security group: cip-security-group
   - Allow SSH (22) from My IP
   - Allow HTTP (80) from Anywhere
   - Allow HTTPS (443) from Anywhere
   - Allow Custom TCP (3000) from Anywhere (Frontend)
   - Allow Custom TCP (8080) from Anywhere (Backend)
   - Allow Custom TCP (8000) from Anywhere (ML Service)
   
   Storage: 30 GB gp3
   
   Click "Launch Instance"
   ```

3. **Allocate Elastic IP**
   ```
   EC2 Dashboard → Elastic IPs → Allocate Elastic IP
   
   Select the new IP → Actions → Associate Elastic IP
   
   Select your instance → Associate
   ```

### **Step 2: Connect to EC2 Instance**

**Windows (PowerShell):**
```powershell
# Set permissions on key file
icacls "your-key.pem" /inheritance:r
icacls "your-key.pem" /grant:r "%username%:R"

# Connect via SSH
ssh -i "your-key.pem" ubuntu@YOUR_ELASTIC_IP
```

**Mac/Linux:**
```bash
# Set permissions
chmod 400 your-key.pem

# Connect
ssh -i your-key.pem ubuntu@YOUR_ELASTIC_IP
```

### **Step 3: Install Required Software**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Java 17
sudo apt install openjdk-17-jdk -y
java -version

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v

# Install Python 3.11
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.11 python3.11-venv python3-pip -y
python3.11 --version

# Install PostgreSQL Client
sudo apt install postgresql-client -y

# Install Git
sudo apt install git -y

# Install Maven
sudo apt install maven -y
mvn -version

# Install PM2 (Process Manager)
sudo npm install -g pm2

# Install Nginx (Reverse Proxy)
sudo apt install nginx -y
```

### **Step 4: Setup PostgreSQL Database (RDS)**

**Option A: Use AWS RDS (Recommended)**

1. **Create RDS Instance**
   ```
   RDS Dashboard → Create database
   
   Engine: PostgreSQL 15
   Templates: Free tier (or Dev/Test)
   
   DB Instance: db.t3.micro (Free tier) or db.t3.small
   
   Settings:
   - DB instance identifier: cip-database
   - Master username: postgres
   - Master password: [Create strong password]
   
   Storage: 20 GB gp3
   
   Connectivity:
   - VPC: Same as EC2
   - Public access: Yes (for now)
   - Security group: Create new
     - Allow PostgreSQL (5432) from EC2 security group
   
   Database name: cip_db
   
   Click "Create database"
   ```

2. **Wait for RDS to be available** (5-10 minutes)

3. **Get RDS Endpoint**
   ```
   RDS Dashboard → Databases → cip-database
   
   Copy "Endpoint" (e.g., cip-database.xxxxx.us-east-1.rds.amazonaws.com)
   ```

**Option B: Install PostgreSQL on EC2 (Not Recommended)**

```bash
# Install PostgreSQL
sudo apt install postgresql postgresql-contrib -y

# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database
sudo -u postgres psql
CREATE DATABASE cip_db;
CREATE USER cip_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE cip_db TO cip_user;
\q
```

### **Step 5: Clone and Setup Application**

```bash
# Create application directory
cd /home/ubuntu
mkdir apps
cd apps

# Clone repository
git clone https://github.com/abhaysahu-cse/career-intelligence-platform-light.git
cd career-intelligence-platform-light

# Initialize submodules
git submodule update --init --recursive
```

### **Step 6: Setup Backend**

```bash
cd /home/ubuntu/apps/career-intelligence-platform-light/cip-backend-lite

# Create environment file
cat > .env << EOF
DB_HOST=YOUR_RDS_ENDPOINT
DB_PORT=5432
DB_NAME=cip_db
DB_USER=postgres
DB_PASSWORD=YOUR_RDS_PASSWORD
JWT_SECRET=$(openssl rand -base64 32)
GEMINI_API_KEY=AIzaSyB0dzGSDGFEFJQ8aZkoYLzqwhvTKbuTcVc
EMAIL_USERNAME=growingabhay05@gmail.com
EMAIL_PASSWORD=ozkswwmdrfxxfkcg
STORAGE_PATH=/home/ubuntu/apps/storage
BASE_URL=http://YOUR_ELASTIC_IP:3000
ML_SERVICE_URL=http://localhost:8000
EOF

# Create storage directory
mkdir -p /home/ubuntu/apps/storage/certificates
mkdir -p /home/ubuntu/apps/storage/resumes

# Build application
mvn clean package -DskipTests

# Create PM2 ecosystem file
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'cip-backend',
    script: 'java',
    args: '-jar target/cip-backend-lite-2.0.0.jar',
    cwd: '/home/ubuntu/apps/career-intelligence-platform-light/cip-backend-lite',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production'
    }
  }]
};
EOF

# Start backend with PM2
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

### **Step 7: Setup ML Service**

```bash
cd /home/ubuntu/apps/career-intelligence-platform-light/cip-ml

# Create virtual environment
python3.11 -m venv venv
source venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Download spaCy model
python -m spacy download en_core_web_sm

# Create environment file
cat > .env << EOF
DATABASE_URL=postgresql://postgres:YOUR_RDS_PASSWORD@YOUR_RDS_ENDPOINT:5432/cip_db
GEMINI_API_KEY=AIzaSyB0dzGSDGFEFJQ8aZkoYLzqwhvTKbuTcVc
EOF

# Create PM2 config
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'cip-ml',
    script: 'venv/bin/python',
    args: 'main.py',
    cwd: '/home/ubuntu/apps/career-intelligence-platform-light/cip-ml',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G'
  }]
};
EOF

# Start ML service
pm2 start ecosystem.config.js
pm2 save
```

### **Step 8: Setup Frontend**

```bash
cd /home/ubuntu/apps/career-intelligence-platform-light/cip-web

# Create environment file
cat > .env.local << EOF
NEXT_PUBLIC_API_URL=http://YOUR_ELASTIC_IP:8080
EOF

# Install dependencies
npm install

# Build for production
npm run build

# Create PM2 config
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'cip-frontend',
    script: 'npm',
    args: 'start',
    cwd: '/home/ubuntu/apps/career-intelligence-platform-light/cip-web',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '512M',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    }
  }]
};
EOF

# Start frontend
pm2 start ecosystem.config.js
pm2 save
```

### **Step 9: Configure Nginx (Reverse Proxy)**

```bash
# Create Nginx configuration
sudo nano /etc/nginx/sites-available/cip-platform

# Add this configuration:
```

```nginx
# Frontend
server {
    listen 80;
    server_name YOUR_ELASTIC_IP;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Backend API
server {
    listen 8080;
    server_name YOUR_ELASTIC_IP;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# ML Service
server {
    listen 8000;
    server_name YOUR_ELASTIC_IP;

    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/cip-platform /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

### **Step 10: Verify Deployment**

```bash
# Check all services
pm2 status

# Check logs
pm2 logs cip-backend --lines 50
pm2 logs cip-ml --lines 50
pm2 logs cip-frontend --lines 50

# Test endpoints
curl http://localhost:8080/actuator/health
curl http://localhost:8000/health
curl http://localhost:3000
```

### **Step 11: Access Your Application**

Open browser and navigate to:
- **Frontend:** `http://YOUR_ELASTIC_IP`
- **Backend API:** `http://YOUR_ELASTIC_IP:8080/actuator/health`
- **ML Service:** `http://YOUR_ELASTIC_IP:8000/health`

---

## 🌐 Domain & SSL Setup (Optional but Recommended)

### **Step 1: Purchase Domain**
- Namecheap: ~$10/year
- GoDaddy: ~$12/year
- AWS Route 53: ~$12/year

### **Step 2: Configure Route 53**

```bash
# In AWS Console
Route 53 → Hosted Zones → Create Hosted Zone

Domain name: yourdomain.com
Type: Public hosted zone

Create records:
- Type: A
  Name: @ (root)
  Value: YOUR_ELASTIC_IP

- Type: A
  Name: www
  Value: YOUR_ELASTIC_IP

- Type: A
  Name: api
  Value: YOUR_ELASTIC_IP
```

### **Step 3: Get Free SSL Certificate**

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Auto-renewal
sudo certbot renew --dry-run
```

### **Step 4: Update Nginx for HTTPS**

Certbot will automatically update Nginx configuration.

---

## 📊 Monitoring & Maintenance

### **Setup CloudWatch (AWS Monitoring)**

```bash
# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb

# Configure monitoring
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

### **PM2 Monitoring**

```bash
# Monitor processes
pm2 monit

# View logs
pm2 logs

# Restart services
pm2 restart all

# Save configuration
pm2 save
```

### **Database Backups**

```bash
# Manual backup
pg_dump -h YOUR_RDS_ENDPOINT -U postgres -d cip_db > backup.sql

# Automated backups (RDS does this automatically)
# Configure in RDS → Automated backups → Retention period: 7 days
```

### **Update Application**

```bash
# Pull latest code
cd /home/ubuntu/apps/career-intelligence-platform-light
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

## 🔒 Security Best Practices

1. **Change default passwords**
2. **Enable AWS MFA**
3. **Restrict security group rules**
4. **Use IAM roles instead of access keys**
5. **Enable CloudTrail for auditing**
6. **Regular security updates:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
7. **Setup firewall:**
   ```bash
   sudo ufw allow 22
   sudo ufw allow 80
   sudo ufw allow 443
   sudo ufw enable
   ```

---

## 💡 Cost Optimization Tips

1. **Use Reserved Instances** - Save 30-50% for 1-year commitment
2. **Stop instances when not in use** - For demo/development
3. **Use Auto Scaling** - Scale down during low traffic
4. **Enable RDS Auto Pause** - For Aurora Serverless
5. **Use S3 for file storage** - Cheaper than EBS
6. **CloudFront CDN** - Reduce data transfer costs
7. **Monitor with AWS Cost Explorer**

---

## 🆘 Troubleshooting

### **Backend not starting:**
```bash
pm2 logs cip-backend --lines 100
# Check database connection
# Check port 8080 availability
```

### **Frontend not loading:**
```bash
pm2 logs cip-frontend --lines 100
# Check API URL in .env.local
# Check port 3000 availability
```

### **Database connection failed:**
```bash
# Test connection
psql -h YOUR_RDS_ENDPOINT -U postgres -d cip_db
# Check security group rules
# Check RDS status
```

### **Out of memory:**
```bash
# Check memory usage
free -h
# Increase swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

---

## 📞 Support Resources

- **AWS Documentation:** https://docs.aws.amazon.com/
- **AWS Free Tier:** https://aws.amazon.com/free/
- **AWS Support:** https://console.aws.amazon.com/support/
- **Community Forums:** https://forums.aws.amazon.com/

---

## ✅ Deployment Checklist

- [ ] AWS account created
- [ ] EC2 instance launched (t3.medium)
- [ ] Elastic IP allocated
- [ ] RDS PostgreSQL created
- [ ] Security groups configured
- [ ] SSH access working
- [ ] All software installed
- [ ] Repository cloned
- [ ] Backend deployed
- [ ] ML service deployed
- [ ] Frontend deployed
- [ ] Nginx configured
- [ ] All services running
- [ ] Application accessible
- [ ] Domain configured (optional)
- [ ] SSL certificate installed (optional)
- [ ] Monitoring setup
- [ ] Backups configured

---

**Estimated Total Time:** 2-3 hours  
**Estimated Monthly Cost:** $52-145 USD  
**Recommended for Demo:** Single EC2 + RDS (~$52/month)

**🎉 Your Career Intelligence Platform will be live on AWS!**
