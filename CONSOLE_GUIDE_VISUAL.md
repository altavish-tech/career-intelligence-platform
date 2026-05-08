# 🎨 Visual Guide: Create EC2 Instance

## 📸 Step-by-Step with What You'll See

---

## Step 1: Open EC2 Console

**URL:** https://console.aws.amazon.com/ec2/

**What you'll see:**
- EC2 Dashboard
- Left sidebar with menu options
- Orange "Launch Instance" button in the center

**Action:** Click **"Launch Instance"**

---

## Step 2: Name Your Instance

**What you'll see:**
- Page title: "Launch an instance"
- First section: "Name and tags"
- Text box for name

**Action:** 
- Type: `cip-platform`

---

## Step 3: Choose AMI (Operating System)

**What you'll see:**
- Section: "Application and OS Images (Amazon Machine Image)"
- Quick Start tab selected
- List of OS options with icons

**Action:**
1. Look for **Ubuntu** (orange/red icon)
2. Click on it
3. You'll see: "Ubuntu Server 22.04 LTS (HVM), SSD Volume Type"
4. Make sure it says: "Free tier eligible" or "64-bit (x86)"
5. AMI ID should be: `ami-0e2c8caa4b6378d8c`

---

## Step 4: Choose Instance Type

**What you'll see:**
- Section: "Instance type"
- Dropdown or list of instance types
- Table with columns: Name, vCPUs, Memory, etc.

**Action:**
1. Click the dropdown or search box
2. Type: `t3.medium`
3. Select: **t3.medium**
   - You'll see: 2 vCPUs, 4 GiB Memory
   - Note: "Not eligible for free tier" (this is OK!)

---

## Step 5: Select Key Pair

**What you'll see:**
- Section: "Key pair (login)"
- Dropdown menu
- Text: "Select a key pair or create a new key pair"

**Action:**
1. Click the dropdown
2. Select: **cip-platform-key**
3. You'll see a checkbox appear
4. Check: "I acknowledge that I have access to the selected private key file"

---

## Step 6: Network Settings

**What you'll see:**
- Section: "Network settings"
- Button: "Edit" on the right side
- Default settings shown

**Action:**
1. Click **"Edit"** button
2. You'll see expanded network options:

   **VPC:**
   - Dropdown will show: `vpc-0a1e0224d8b2b9aaf`
   - Keep this selected

   **Subnet:**
   - Leave as "No preference"

   **Auto-assign public IP:**
   - Make sure it's **Enabled**

   **Firewall (security groups):**
   - Select: **"Select existing security group"** (radio button)
   - Dropdown appears
   - Select: **sg-0b2e86f405b566eaf** (cip-ec2-sg)
   - You'll see rules listed:
     - SSH (22)
     - HTTP (80)
     - HTTPS (443)
     - Custom TCP (3000, 8000, 8080)

---

## Step 7: Configure Storage

**What you'll see:**
- Section: "Configure storage"
- Table showing volume details
- Default: 8 GiB

**Action:**
1. Find the "Size (GiB)" field
2. Change from `8` to `30`
3. Volume type: Select **gp3** (if not already selected)
4. Keep "Delete on termination" checked

---

## Step 8: Advanced Details (Skip)

**What you'll see:**
- Section: "Advanced details" (collapsed)
- Arrow to expand

**Action:**
- **Don't expand this** - leave all defaults

---

## Step 9: Summary Panel (Right Side)

**What you'll see:**
- Right sidebar with summary
- Shows:
  - Number of instances: 1
  - Software Image (AMI): Ubuntu 22.04
  - Instance type: t3.medium
  - Key pair: cip-platform-key
  - Network settings
  - Storage: 30 GiB

**Action:**
- Review to make sure everything matches

---

## Step 10: Launch!

**What you'll see:**
- Bottom right corner
- Orange button: **"Launch instance"**
- Below it: Estimated cost per month

**Action:**
1. Click **"Launch instance"**
2. You'll see a success message:
   - "Success"
   - "Successfully initiated launch of instance i-xxxxx"
3. Click **"View all instances"** (blue link)

---

## Step 11: Wait for Instance

**What you'll see:**
- EC2 Instances page
- Table with your instance
- Columns: Name, Instance ID, Instance state, etc.

**What to watch:**
1. **Instance state** column:
   - First: "Pending" (orange)
   - After 1-2 minutes: "Running" (green)

2. **Status check** column:
   - First: "Initializing"
   - After 2-3 minutes: "2/2 checks passed" (green)

**Action:**
1. Wait for **Instance state** = **Running** (green)
2. Wait for **Status check** = **2/2 checks passed**
3. **Copy the Instance ID** (looks like: `i-0123456789abcdef0`)
   - Click on the instance
   - Instance ID is at the top of the details panel

---

## Step 12: Note Your Instance ID

**What you'll see:**
- Instance details panel at the bottom
- Instance ID at the top (e.g., `i-0123456789abcdef0`)

**Action:**
1. **Copy this Instance ID**
2. Save it somewhere (you'll need it next)

---

## ✅ Done with Console!

Now go back to PowerShell and run:

```powershell
.\complete-deployment.ps1
```

When prompted, paste your Instance ID.

---

## 🎯 Visual Checklist

As you go through the console, check off each item:

- [ ] Clicked "Launch Instance"
- [ ] Named instance: cip-platform
- [ ] Selected Ubuntu 22.04 LTS
- [ ] Selected t3.medium instance type
- [ ] Selected cip-platform-key key pair
- [ ] Clicked "Edit" in Network settings
- [ ] Selected existing security group: sg-0b2e86f405b566eaf
- [ ] Changed storage to 30 GiB gp3
- [ ] Clicked "Launch instance"
- [ ] Saw success message
- [ ] Instance state shows "Running"
- [ ] Status check shows "2/2 checks passed"
- [ ] Copied Instance ID

---

## 🆘 Common Issues

### "Key pair not found"
- Make sure you're in **us-east-1** region (top right)
- Check region selector shows "N. Virginia"

### "Security group not found"
- Make sure you're in **us-east-1** region
- Click "Edit" in Network settings first
- Select "Select existing security group" radio button

### "Instance won't start"
- Check if you have service limits
- Try refreshing the page
- Contact AWS support if issue persists

### "Can't see my instance"
- Make sure you're in **us-east-1** region
- Click "Instances" in left sidebar
- Refresh the page

---

## 💡 Tips

1. **Keep the console tab open** - You might need to check instance status
2. **Don't close PowerShell** - You'll need it for the next steps
3. **Save your Instance ID** - Write it down or copy to notepad
4. **Be patient** - Instance takes 2-3 minutes to be fully ready

---

**Once you have the Instance ID, run `complete-deployment.ps1` to finish!** 🚀
