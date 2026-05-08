# 🔐 AWS Permissions Setup Guide

## Current Issue
Your AWS user `claude-user` doesn't have the necessary permissions to create EC2 instances, RDS databases, and security groups.

---

## 📋 Required Permissions

You need the following AWS permissions:

### **1. EC2 Permissions** (For servers)
- `ec2:CreateKeyPair`
- `ec2:DescribeKeyPairs`
- `ec2:CreateSecurityGroup`
- `ec2:DescribeSecurityGroups`
- `ec2:AuthorizeSecurityGroupIngress`
- `ec2:RunInstances`
- `ec2:DescribeInstances`
- `ec2:CreateTags`
- `ec2:AllocateAddress`
- `ec2:DescribeAddresses`
- `ec2:AssociateAddress`
- `ec2:DescribeVpcs`
- `ec2:DescribeInstanceStatus`

### **2. RDS Permissions** (For database)
- `rds:CreateDBInstance`
- `rds:DescribeDBInstances`
- `rds:ModifyDBInstance`
- `rds:DeleteDBInstance`

---

## 🚀 Quick Setup (2 Methods)

### **Method 1: Use AWS Console (Recommended - 5 minutes)**

#### Step 1: Login to AWS Console
1. Go to: https://console.aws.amazon.com/
2. Login with your AWS account

#### Step 2: Navigate to IAM
1. Search for "IAM" in the top search bar
2. Click on **IAM** (Identity and Access Management)

#### Step 3: Find Your User
1. Click on **Users** in the left sidebar
2. Find and click on **claude-user**

#### Step 4: Attach Policies
1. Click on **Add permissions** button
2. Click **Attach policies directly**
3. Search and select these policies:
   - ✅ **AmazonEC2FullAccess** (For EC2 instances)
   - ✅ **AmazonRDSFullAccess** (For database)
   - ✅ **AmazonVPCFullAccess** (For networking)
4. Click **Next**
5. Click **Add permissions**

#### Step 5: Verify
You should see these policies attached to your user:
- AmazonEC2FullAccess
- AmazonRDSFullAccess
- AmazonVPCFullAccess

---

### **Method 2: Use AWS CLI (Advanced - 2 minutes)**

Run these commands in PowerShell:

```powershell
# Attach EC2 Full Access
aws iam attach-user-policy --user-name claude-user --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

# Attach RDS Full Access
aws iam attach-user-policy --user-name claude-user --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess

# Attach VPC Full Access
aws iam attach-user-policy --user-name claude-user --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess

# Verify permissions
aws iam list-attached-user-policies --user-name claude-user
```

---

## 🔒 Security Best Practice (Optional but Recommended)

Instead of using `FullAccess` policies, you can create a custom policy with only the required permissions:

### Create Custom Policy:

1. Go to IAM → Policies → Create Policy
2. Click **JSON** tab
3. Paste this policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EC2Permissions",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateKeyPair",
                "ec2:DescribeKeyPairs",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeSecurityGroups",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RunInstances",
                "ec2:DescribeInstances",
                "ec2:CreateTags",
                "ec2:AllocateAddress",
                "ec2:DescribeAddresses",
                "ec2:AssociateAddress",
                "ec2:DescribeVpcs",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeImages",
                "ec2:DescribeVolumes",
                "ec2:DescribeSubnets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "RDSPermissions",
            "Effect": "Allow",
            "Action": [
                "rds:CreateDBInstance",
                "rds:DescribeDBInstances",
                "rds:ModifyDBInstance",
                "rds:DeleteDBInstance",
                "rds:AddTagsToResource",
                "rds:ListTagsForResource"
            ],
            "Resource": "*"
        }
    ]
}
```

4. Click **Next**
5. Name: `CIP-Platform-Deploy-Policy`
6. Click **Create policy**
7. Go back to Users → claude-user → Add permissions
8. Attach the `CIP-Platform-Deploy-Policy`

---

## ✅ Verification Steps

After adding permissions, verify they work:

```powershell
# Test EC2 permissions
aws ec2 describe-instances --region us-east-1

# Test RDS permissions
aws rds describe-db-instances --region us-east-1

# Test VPC permissions
aws ec2 describe-vpcs --region us-east-1
```

If all commands run without "AccessDenied" errors, you're ready!

---

## 🚀 After Adding Permissions

Once permissions are added, run the deployment script again:

```powershell
.\simple-aws-deploy.ps1
```

The script will:
1. ✅ Create SSH key pair
2. ✅ Create security groups
3. ✅ Launch RDS database (5-10 minutes)
4. ✅ Launch EC2 instance
5. ✅ Allocate Elastic IP
6. ✅ Save all credentials

---

## 💰 Cost Reminder

With these permissions, you can create resources that cost money:
- EC2 t3.medium: ~$30/month
- RDS db.t3.micro: ~$12/month
- Storage & IP: ~$10/month
- **Total: ~$52/month**

---

## 🆘 Troubleshooting

### Issue: "You are not authorized to perform this operation"
**Solution:** Make sure you attached the policies correctly. Wait 1-2 minutes for AWS to propagate the permissions.

### Issue: "Cannot attach policy"
**Solution:** You might not have IAM permissions. Ask your AWS account administrator to add these policies to your user.

### Issue: "Policy not found"
**Solution:** Make sure you're using the correct policy ARNs:
- `arn:aws:iam::aws:policy/AmazonEC2FullAccess`
- `arn:aws:iam::aws:policy/AmazonRDSFullAccess`
- `arn:aws:iam::aws:policy/AmazonVPCFullAccess`

---

## 📞 Need Help?

If you don't have permission to add policies to your user:
1. Contact your AWS account administrator
2. Share this document with them
3. Ask them to attach the three policies mentioned above

---

## ✅ Quick Checklist

- [ ] Logged into AWS Console
- [ ] Navigated to IAM → Users → claude-user
- [ ] Attached AmazonEC2FullAccess policy
- [ ] Attached AmazonRDSFullAccess policy
- [ ] Attached AmazonVPCFullAccess policy
- [ ] Verified permissions with test commands
- [ ] Ready to run deployment script

---

**Once permissions are added, the deployment will take about 15-20 minutes total!**
