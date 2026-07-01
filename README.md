# Terraform AWS Learning Projects

Welcome! This repository is a **step-by-step hands-on guide** for learning Terraform by building real AWS infrastructure.

If you are new to Terraform or AWS, start here. Each folder teaches **one concept** at a time, so you can learn without getting overwhelmed.

---

## What is Terraform?

**Terraform** is an Infrastructure as Code (IaC) tool. Instead of clicking buttons in the AWS Console to create servers, you write code in `.tf` files and Terraform creates the resources for you.

**Why use it?**
- Repeatable — run the same code again and get the same result
- Version controlled — track changes in Git
- Easy to update or delete — change code and run `terraform apply` or `terraform destroy`

**Basic workflow:**

```
Write code (.tf files) → terraform init → terraform plan → terraform apply → AWS resources created
```

---

## AWS Resources Used in This Project

| AWS Service | What it is | Used for |
|-------------|------------|----------|
| **EC2** | A virtual server (like a computer in the cloud) | Running applications |
| **S3** | Cloud storage (like a folder in the cloud) | Storing files |
| **AMI** | A template/image for an EC2 instance | Choosing the OS (we use Amazon Linux 2) |

---

## Before You Start (Prerequisites)

### Step 1: Install Terraform

1. Download from [terraform.io/downloads](https://www.terraform.io/downloads)
2. Verify installation:

```powershell
terraform version
```

You should see something like `Terraform v1.x.x`.

### Step 2: Set Up AWS Credentials

You need an AWS account. Then configure your credentials using one of these methods:

**Option A — AWS CLI (recommended for beginners):**

```powershell
aws configure
```

Enter your:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (use `eu-north-1` to match this project)
- Default output format (`json`)

**Option B — Environment variables:**

```powershell
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_DEFAULT_REGION="eu-north-1"
```

### Step 3: Verify AWS Access

```powershell
aws sts get-caller-identity
```

If this returns your account ID, you are ready.

> **Cost note:** EC2 and S3 may incur charges. We use `t3.micro` (free tier eligible in many regions). Always run `terraform destroy` when you are done to avoid unexpected bills.

---

## Understanding Terraform Files

Every project folder contains these file types:

| File | Purpose | Beginner explanation |
|------|---------|----------------------|
| `main.tf` | Main infrastructure code | Where resources (EC2, S3) are defined |
| `variables.tf` | Input values | Settings you can change without editing main code |
| `outputs.tf` / `output.tf` | Results after apply | Shows useful info like IP address after creation |
| `versions.tf` | Provider versions | Locks which Terraform provider version to use |
| `.terraform.lock.hcl` | Dependency lock file | Auto-generated; safe to commit |
| `terraform.tfstate` | State file | Tracks what Terraform created (**do not commit**) |

---

## Learning Path (Follow This Order)

Start from folder 1 and move forward. Each lesson builds on the previous one.

```
1. variables/                        → Learn input variables
2. localvariable&conditionalexpression/ → Learn locals and if/else logic
3. resourcedependencies/             → Learn resource ordering (depends_on)
4. module/                           → Learn reusable code (modules)
5. workspace/                        → Learn multiple environments (dev/prod)
```

---

## How to Run Any Project (Step by Step)

Open PowerShell, go to the project root, then enter a folder:

```powershell
cd C:\Users\sonar\OneDrive\Desktop\Terraform
cd variables    # change folder name for each lesson
```

Run these commands **in order**:

| Step | Command | What it does |
|------|---------|--------------|
| 1 | `terraform init` | Downloads the AWS provider. Run once per folder. |
| 2 | `terraform validate` | Checks your code for syntax errors. |
| 3 | `terraform plan` | Shows what will be created/changed **without** making changes. |
| 4 | `terraform apply` | Creates resources in AWS. Type `yes` when prompted. |
| 5 | `terraform output` | Shows useful values (IP address, instance ID, etc.). |
| 6 | `terraform destroy` | Deletes all resources. **Always do this when finished.** |

---

## Lesson 1: `variables/`

### What you will learn
How to use **variables** so you can change settings (region, instance size, name) without editing `main.tf`.

### Files in this folder

| File | What it contains |
|------|------------------|
| `main.tf` | AWS provider, AMI lookup, EC2 instance |
| `variables.tf` | `aws_region`, `instance_type`, `instance_name` |
| `outputs.tf` | Instance ID, public IP, DNS, private IP |

### Key concept

```hcl
instance_type = var.instance_type   # reads value from variables.tf
```

### Commands

```powershell
cd variables
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform output public_ip
terraform show
terraform destroy
```

### What to expect after `terraform apply`
- One EC2 instance in AWS
- Outputs show the instance IP address and ID
- Check AWS Console → EC2 → Instances

---

## Lesson 2: `localvariable&conditionalexpression/`

### What you will learn
How to use **locals** (temporary computed values) and **conditional expressions** (if/else in one line).

### Files in this folder

| File | What it contains |
|------|------------------|
| `main.tf` | Locals block with ternary `? :` expression |
| `variables.tf` | Input variables |
| `outputs.tf` | Includes `name_tag` output |

### Key concept

```hcl
locals {
  name_tag = var.instance_type == "t3.micro" ? "Micro Instance" : "Standard Instance"
}
```

If instance type is `t3.micro` → name is `"Micro Instance"`, otherwise `"Standard Instance"`.

### Commands

```powershell
cd "localvariable&conditionalexpression"
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform output name_tag
terraform show
terraform destroy
```

> **Note:** Use quotes around the folder name because it contains `&`.

---

## Lesson 3: `resourcedependencies/`

### What you will learn
How to control **creation order** when one resource must exist before another.

### Files in this folder

| File | What it contains |
|------|------------------|
| `main.tf` | S3 bucket + EC2 with `depends_on` |
| `variables.tf` | Region, instance type, bucket name |
| `output.tf` | Bucket and instance details |

### Key concept

```hcl
depends_on = [aws_s3_bucket.my_bucket]
```

Terraform creates the S3 bucket **first**, then the EC2 instance.

### Commands

```powershell
cd resourcedependencies
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform output bucket_id
terraform output bucket_arn
terraform output public_ip
terraform show
terraform destroy
```

### What to expect after `terraform apply`
- One S3 bucket in AWS Console → S3
- One EC2 instance in AWS Console → EC2
- Bucket name includes your account ID for uniqueness

---

## Lesson 4: `module/`

### What you will learn
How to organize code into **modules** — reusable building blocks.

Think of a module like a function: you call it from `main.tf` and pass inputs; it returns outputs.

### Files in this folder

| File | What it contains |
|------|------------------|
| `main.tf` | Calls the `ec2_s3` module |
| `variables.tf` | Inputs passed to the module |
| `outputs.tf` | Outputs from the module |
| `versions.tf` | Provider version requirements |
| `modules/ec2-s3/main.tf` | Actual S3 + EC2 resources |
| `modules/ec2-s3/variables.tf` | Module inputs |
| `modules/ec2-s3/outputs.tf` | Module outputs |

### Key concept

```hcl
module "ec2_s3" {
  source        = "./modules/ec2-s3"
  instance_type = var.instance_type
}
```

### Commands

```powershell
cd module
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform output bucket_id
terraform output instance_id
terraform show
terraform destroy
```

---

## Lesson 5: `workspace/`

### What you will learn
How to use **workspaces** to manage multiple environments (e.g. `dev` and `prod`) with separate state files.

### Files in this folder

| File | What it contains |
|------|------------------|
| `main.tf` | EC2 with name tag using `terraform.workspace` |
| `variables.tf` | Region and instance type |
| `outputs.tf` | Workspace name and instance details |

### Key concept

```hcl
Name = "ec2-${terraform.workspace}"
```

- In `dev` workspace → instance named `ec2-dev`
- In `prod` workspace → instance named `ec2-prod`

### Commands

```powershell
cd workspace
terraform init
terraform validate

# Create and deploy dev environment
terraform workspace new dev
terraform plan
terraform apply
terraform output

# Create and deploy prod environment
terraform workspace new prod
terraform plan
terraform apply
terraform output

# Switch between workspaces
terraform workspace list
terraform workspace select dev
terraform show

# Clean up each workspace
terraform workspace select dev
terraform destroy

terraform workspace select prod
terraform destroy
```

---

## Common Terraform Commands (Quick Reference)

| Command | When to use it |
|---------|----------------|
| `terraform init` | First time in a folder, or after adding a module |
| `terraform validate` | Check code syntax before plan/apply |
| `terraform plan` | Preview changes safely |
| `terraform apply` | Create or update infrastructure |
| `terraform apply -auto-approve` | Apply without typing `yes` |
| `terraform output` | View results after apply |
| `terraform output public_ip` | View one specific output |
| `terraform show` | View full details of created resources |
| `terraform destroy` | Delete everything Terraform created |
| `terraform fmt` | Auto-format your `.tf` files |
| `terraform workspace list` | See all workspaces |
| `terraform workspace new <name>` | Create a new workspace |
| `terraform workspace select <name>` | Switch workspace |

---

## Common Beginner Mistakes and Fixes

| Problem | Likely cause | Fix |
|---------|--------------|-----|
| `No valid credential sources found` | AWS not configured | Run `aws configure` |
| `Error: Reference to undeclared input variable` | Variable missing in `variables.tf` | Add the variable block |
| `BucketAlreadyExists` | S3 name taken globally | Use a unique bucket name (this project adds account ID) |
| Command fails in wrong folder | Not inside project folder | `cd` into the correct lesson folder first |
| `terraform: command not found` | Terraform not installed | Install and restart terminal |
| Resources still running / charges | Forgot to destroy | Run `terraform destroy` in each folder |

---

## Default Settings Used in All Projects

| Setting | Value | Meaning |
|---------|-------|---------|
| Region | `eu-north-1` | AWS data center location (Stockholm) |
| Instance type | `t3.micro` | Small, low-cost EC2 instance |
| OS image | Amazon Linux 2 | Linux OS (auto-fetched latest AMI) |

---

## Git Commands (Push Code to GitHub)

Use these from the project root to save your code online:

```powershell
cd C:\Users\sonar\OneDrive\Desktop\Terraform
git status
git add .
git commit -m "Add README and Terraform lessons"
git push
```

**Files safe to commit:** `.tf` files, `README.md`, `.gitignore`, `.terraform.lock.hcl`

**Never commit:** `terraform.tfstate`, `.terraform/` folder (contains secrets and local data)

---

## Repository

[https://github.com/v-sonarkar/Terraform-repo](https://github.com/v-sonarkar/Terraform-repo)

---

## Quick Start Checklist

- [ ] Install Terraform (`terraform version`)
- [ ] Configure AWS (`aws configure`)
- [ ] Verify AWS access (`aws sts get-caller-identity`)
- [ ] Start with `variables/` folder
- [ ] Run `init` → `plan` → `apply`
- [ ] Check resources in AWS Console
- [ ] Run `terraform destroy` when done
- [ ] Move to the next lesson folder

Happy learning!
