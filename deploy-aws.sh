#!/bin/bash

# ============================================
# CIP Platform - AWS EC2 Deployment Script
# ============================================

set -e  # Exit on error

echo "🚀 Starting Career Intelligence Platform Deployment..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# ============================================
# Step 1: Collect Configuration
# ============================================

echo "📋 Configuration Setup"
echo "====================="
echo ""

read -p "Enter RDS Endpoint (e.g., cip-db.xxxxx.rds.amazonaws.com): " RDS_ENDPOINT
read -p "Enter RDS Password: " -s RDS_PASSWORD
echo ""
read -p "Enter Your Elastic IP: " ELASTIC_IP
read -p "Enter Gemini API Key: " GEMINI_API_KEY
read -p "Enter Gmail Email: " GMAIL_EMAIL
read -p "Enter Gmail App Password: " -s GMAIL_PASSWORD
echo ""

print_info "Configuration collected!"
echo ""

# ============================================
# Step 2: Update System
# ============================================

print_info "Updating system packages..."
sudo apt update && sudo apt upgrade -y
print_success "System updated!"
echo ""

# ============================================
# Step 3: Install Required Software
# ============================================

print_info "Installing Java 17..."
sudo apt install openjdk-17-jdk -y
java -version
print_success "Java installed!"
echo ""

print_info "Installing Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
print_success "Node.js installed!"
echo ""

print_info "Installing Python 3.11..."
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.11 python3.11-venv python3-pip -y
python3.11 --version
print_success "Python installed!"
echo ""

print_info "Installing additional tools..."
sudo apt install postgresql-client git maven nginx -y
sudo npm install -g pm2
print_success "Additional tools installed!"
echo ""

# ============================================
# Step 4: Clone Repository
# ============================================

print_info "Cloning repository..."
cd /home/ubuntu
mkdir -p apps
cd apps

if [ -d "career-intelligence-platform-light" ]; then
    print_info "Repository already exists, pulling latest changes..."
    cd career-intelligence-platform-light
    git pull origin main
    git submodule update --init --recursive
else
    git clone https://github.com/abhaysahu-cse/career-intelligence-platform-light.git
    cd career-intelligence-platform-light
    git submodule update --init --recursive
fi

print_success "Repository ready!"
echo ""

# ============================================
# Step 5: Setup Backend
# ============================================

print_info "Setting up Backend..."
cd /home/ubuntu/apps/career-intelligence-platform-light/cip-backend-lite

# Create environment file
cat > .env << EOF
DB_HOST=${RDS_ENDPOINT}
DB_PORT=5432
DB_NAME=cip_db
DB_USER=postgres
DB_PASSWORD=${RDS_PASSWORD}
JWT_SECRET=$(openssl rand -base64 32)
GEMINI_API_KEY=${GEMINI_API_KEY}
EMAIL_USERNAME=${GMAIL_EMAIL}
EMAIL_PASSWORD=${GMAIL_PASSWORD}
STORAGE_PATH=/home/ubuntu/apps/storage
BASE_URL=http://${ELASTIC_IP}:3000
ML_SERVICE_URL=http://localhost:8000
EOF

# Create storage directories
mkdir -p /home/ubuntu/apps/storage/certificates
mkdir -p /home/ubuntu/apps/storage/resumes

# Build backend
print_info "Building backend (this may take a few minutes)..."
mvn clean package -DskipTests

# Create PM2 config
cat > ecosystem.config.js << 'EOFPM2'
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
EOFPM2

# Stop if already running
pm2 delete cip-backend 2>/dev/null || true

# Start backend
pm2 start ecosystem.config.js
print_success "Backend deployed!"
echo ""

# ============================================
# Step 6: Setup ML Service
# ============================================

print_info "Setting up ML Service..."
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
DATABASE_URL=postgresql://postgres:${RDS_PASSWORD}@${RDS_ENDPOINT}:5432/cip_db
GEMINI_API_KEY=${GEMINI_API_KEY}
EOF

# Create PM2 config
cat > ecosystem.config.js << 'EOFPM2'
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
EOFPM2

# Stop if already running
pm2 delete cip-ml 2>/dev/null || true

# Start ML service
pm2 start ecosystem.config.js
print_success "ML Service deployed!"
echo ""

# ============================================
# Step 7: Setup Frontend
# ============================================

print_info "Setting up Frontend..."
cd /home/ubuntu/apps/career-intelligence-platform-light/cip-web

# Create environment file
cat > .env.local << EOF
NEXT_PUBLIC_API_URL=http://${ELASTIC_IP}:8080
EOF

# Install dependencies
print_info "Installing frontend dependencies (this may take a few minutes)..."
npm install

# Build for production
print_info "Building frontend (this may take a few minutes)..."
npm run build

# Create PM2 config
cat > ecosystem.config.js << 'EOFPM2'
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
EOFPM2

# Stop if already running
pm2 delete cip-frontend 2>/dev/null || true

# Start frontend
pm2 start ecosystem.config.js
print_success "Frontend deployed!"
echo ""

# ============================================
# Step 8: Configure Nginx
# ============================================

print_info "Configuring Nginx..."

sudo tee /etc/nginx/sites-available/cip-platform > /dev/null << EOF
# Frontend
server {
    listen 80;
    server_name ${ELASTIC_IP};

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable site
sudo ln -sf /etc/nginx/sites-available/cip-platform /etc/nginx/sites-enabled/

# Test and restart Nginx
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

print_success "Nginx configured!"
echo ""

# ============================================
# Step 9: Save PM2 Configuration
# ============================================

print_info "Saving PM2 configuration..."
pm2 save
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
print_success "PM2 configured for auto-start!"
echo ""

# ============================================
# Step 10: Setup Firewall
# ============================================

print_info "Configuring firewall..."
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable
print_success "Firewall configured!"
echo ""

# ============================================
# Final Status Check
# ============================================

echo ""
echo "============================================"
echo "🎉 Deployment Complete!"
echo "============================================"
echo ""

print_info "Checking service status..."
sleep 5
pm2 status

echo ""
echo "📊 Service URLs:"
echo "   Frontend:  http://${ELASTIC_IP}"
echo "   Backend:   http://${ELASTIC_IP}:8080/actuator/health"
echo "   ML Service: http://${ELASTIC_IP}:8000/health"
echo ""

print_info "Testing endpoints..."
echo ""

# Test backend
if curl -s http://localhost:8080/actuator/health > /dev/null; then
    print_success "Backend is running!"
else
    print_error "Backend is not responding. Check logs: pm2 logs cip-backend"
fi

# Test ML service
if curl -s http://localhost:8000/health > /dev/null; then
    print_success "ML Service is running!"
else
    print_error "ML Service is not responding. Check logs: pm2 logs cip-ml"
fi

# Test frontend
if curl -s http://localhost:3000 > /dev/null; then
    print_success "Frontend is running!"
else
    print_error "Frontend is not responding. Check logs: pm2 logs cip-frontend"
fi

echo ""
echo "============================================"
echo "📝 Useful Commands:"
echo "============================================"
echo "  View all services:  pm2 status"
echo "  View logs:          pm2 logs"
echo "  Restart all:        pm2 restart all"
echo "  Stop all:           pm2 stop all"
echo "  Monitor:            pm2 monit"
echo ""
echo "============================================"
echo "🚀 Your CIP Platform is now live!"
echo "============================================"
echo ""
