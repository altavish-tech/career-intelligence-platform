# 📸 Step-by-Step AWS Permissions Setup (With Screenshots Guide)

## 🎯 Goal
Add permissions to your AWS user `claude-user` so you can deploy the CIP Platform.

**Time Required:** 5 minutes  
**Cost:** FREE (permissions don't cost anything)

---

## 📋 Step-by-Step Instructions

### **Step 1: Login to AWS Console**

1. Open your browser
2. Go to: **https://console.aws.amazon.com/**
3. Login with your AWS credentials
4. You should see the AWS Management Console

---

### **Step 2: Navigate to IAM Service**

1. In the top search bar, type: **IAM**
2. Click on **IAM** (Identity and Access Management)
3. You'll see the IAM Dashboard

---

### **Step 3: Go to Users**

1. On the left sidebar, click **Users**
2. You'll see a list of IAM users
3. Find and click on **claude-user**

---

### **Step 4: Add Permissions**

1. You'll see the user details page
2. Click on the **Permissions** tab (if not already selected)
3. Click the **Add permissions** button (blue button on the right)
4. Select **Attach policies directly**

---

### **Step 5: Search and Select Policies**

Now you need to add 3 policies. For each policy:

#### **Policy 1: AmazonEC2FullAccess**
1. In the search box, type: **AmazonEC2FullAccess**
2. Check the checkbox next to **AmazonEC2FullAccess**
3. You should see a checkmark ✅

#### **Policy 2: AmazonRDSFullAccess**
1. Clear the search box
2. Type: **AmazonRDSFullAccess**
3. Check the checkbox next to **AmazonRDSFullAccess**
4. You should see a checkmark ✅

#### **Policy 3: AmazonVPCFullAccess**
1. Clear the search box
2. Type: **AmazonVPCFullAccess**
3. Check the checkbox next to **AmazonVPCFullAccess**
4. You should see a checkmark ✅

**You should now have 3 policies selected with checkmarks!**

---

### **Step 6: Review and Add**

1. Click the **Next** button at the bottom
2. Review the permissions (you should see all 3 policies listed)
3. Click **Add permissions** button

---

### **Step 7: Verify**

1. You should see a success message: "Successfully added permissions"
2. Scroll down to the **Permissions policies** section
3. You should see these 3 policies listed:
   - ✅ AmazonEC2FullAccess
   - ✅ AmazonRDSFullAccess
   - ✅ AmazonVPCFullAccess

---

## ✅ Verification

Now let's verify the permissions work!

### **Option 1: Run Verification Script (Recommended)**

Open PowerShell and run:

```powershell
.\check-aws-permissions.ps1
```

You should see:
```
Testing EC2 permissions...
  EC2: OK
Testing RDS permissions...
  RDS: OK
Testing VPC permissions...
  VPC: OK

All permissions are working!
You can now run: .\simple-aws-deploy.ps1
```

### **Option 2: Manual Verification**

Run these commands in PowerShell:

```powershell
# Test EC2
aws ec2 describe-instances --region us-east-1

# Test RDS
aws rds describe-db-instances --region us-east-1

# Test VPC
aws ec2 describe-vpcs --region us-east-1
```

If all commands run without "AccessDenied" errors, you're good! ✅

---

## 🚀 Next Steps

Once permissions are verified, run the deployment:

```powershell
.\simple-aws-deploy.ps1
```

This will:
1. Create SSH key pair (saved as `cip-platform-key.pem`)
2. Create security groups
3. Launch PostgreSQL database (takes 5-10 minutes)
4. Launch EC2 instance
5. Allocate Elastic IP
6. Save all information to `deployment-info.json`

---

## 🆘 Troubleshooting

### **Problem: "You don't have permission to attach policies"**

**Solution:** You need administrator access to add policies. Options:
1. Ask your AWS account owner/administrator to add these policies
2. Share this document with them
3. They can follow the same steps above

### **Problem: "Policy not found"**

**Solution:** Make sure you're typing the exact policy names:
- `AmazonEC2FullAccess` (capital letters matter!)
- `AmazonRDSFullAccess`
- `AmazonVPCFullAccess`

### **Problem: "Still getting AccessDenied after adding policies"**

**Solution:** 
1. Wait 1-2 minutes for AWS to propagate the permissions
2. Close and reopen PowerShell
3. Run the verification script again

### **Problem: "Cannot find user claude-user"**

**Solution:** The user might have a different name. Check:
```powershell
aws sts get-caller-identity
```
Look at the "Arn" field to see your actual username.

---

## 📞 Alternative: Use AWS CLI to Add Permissions

If you have admin access, you can add permissions via CLI:

```powershell
# Add EC2 permissions
aws iam attach-user-policy `
  --user-name claude-user `
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

# Add RDS permissions
aws iam attach-user-policy `
  --user-name claude-user `
  --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess

# Add VPC permissions
aws iam attach-user-policy `
  --user-name claude-user `
  --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess

# Verify
aws iam list-attached-user-policies --user-name claude-user
```

---

## 💡 What These Permissions Allow

### **AmazonEC2FullAccess**
- Create and manage virtual servers (EC2 instances)
- Create security groups (firewalls)
- Allocate IP addresses
- Create SSH key pairs

### **AmazonRDSFullAccess**
- Create and manage databases (PostgreSQL)
- Configure database settings
- Create database backups

### **AmazonVPCFullAccess**
- Manage virtual networks
- Configure network security
- Set up subnets and routing

---

## 🔒 Security Note

These are "FullAccess" policies which give broad permissions. For production:
- Consider using more restrictive custom policies
- Enable MFA (Multi-Factor Authentication)
- Regularly review and audit permissions
- Use IAM roles instead of user credentials when possible

---

## ✅ Final Checklist

Before running deployment:

- [ ] Logged into AWS Console
- [ ] Found IAM service
- [ ] Located claude-user
- [ ] Added AmazonEC2FullAccess policy
- [ ] Added AmazonRDSFullAccess policy
- [ ] Added AmazonVPCFullAccess policy
- [ ] Verified all 3 policies are attached
- [ ] Ran verification script successfully
- [ ] Ready to deploy!

---

## 🎉 You're Ready!

Once all checkboxes are checked, run:

```powershell
.\simple-aws-deploy.ps1
```

The deployment will take about 15-20 minutes and will create:
- 1 EC2 instance (t3.medium)
- 1 RDS database (PostgreSQL)
- 1 Elastic IP
- Security groups
- SSH key pair

**Total cost: ~$52/month**

---

**Need help? Check AWS_PERMISSIONS_SETUP.md for more details!**
