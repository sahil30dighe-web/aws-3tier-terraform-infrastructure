# AWS 3-Tier Infrastructure using Terraform (IaC)

## Overview

This project demonstrates the provisioning of a production-style AWS infrastructure using Terraform (Infrastructure as Code). The infrastructure follows a multi-tier architecture pattern with separate networking, security, compute, and load balancing layers.

The entire environment is provisioned through Terraform, enabling repeatable, automated, and version-controlled infrastructure deployments.

---

## Architecture

```text
Internet
    │
    ▼
Application Load Balancer (ALB)
    │
    ▼
Target Group
    │
    ▼
Auto Scaling Group (ASG)
    │
 ┌──┴──┐
 ▼     ▼
EC2   EC2
(Application Servers)
    │
    ▼
Private Database Tier
(Database Subnets Ready for RDS)
```

---

## AWS Services Used

### Networking

* Amazon VPC
* Internet Gateway
* NAT Gateway
* Elastic IP
* Route Tables
* Public Subnets
* Private Application Subnets
* Private Database Subnets

### Identity & Security

* IAM Users
* IAM Groups
* IAM Roles
* IAM Policies
* MFA Enforcement Policy
* Security Groups

### Compute

* EC2 Launch Template
* Auto Scaling Group
* User Data Automation

### Load Balancing

* Application Load Balancer (ALB)
* Target Group
* Health Checks

---

## Security Architecture

### ALB Security Group

* HTTP (80) from Internet
* HTTPS (443) from Internet

### Application Security Group

* Accepts traffic only from ALB

### Database Security Group

* Accepts MySQL traffic only from Application Layer

---

## IAM Implementation

### Groups

* Admins
* Developers
* Finance

### Custom Policies

* Require-MFA
* RDS-Protection-Policy

### EC2 Role Permissions

* AmazonS3ReadOnlyAccess
* CloudWatchAgentServerPolicy

---

## Terraform Project Structure

```text
.
├── provider.tf
├── variables.tf
├── main.tf
├── security.tf
├── iam.tf
├── compute.tf
├── outputs.tf
├── terraform.tfvars
├── .gitignore
└── README.md
```

---

## Deployment

Initialize Terraform:

```bash
terraform init
```

Validate Configuration:

```bash
terraform validate
```

Review Changes:

```bash
terraform plan
```

Deploy Infrastructure:

```bash
terraform apply
```

Destroy Infrastructure:

```bash
terraform destroy
```

---

## Outputs

The project provides useful Terraform outputs:

* VPC ID
* Internet Gateway ID
* NAT Gateway ID
* Application Load Balancer DNS Name

---

## Skills Demonstrated

* Terraform
* Infrastructure as Code (IaC)
* AWS Networking
* IAM & Security
* Auto Scaling
* Load Balancing
* Linux Administration
* Git & GitHub

---

## Future Enhancements

* Amazon RDS Deployment
* CloudWatch Monitoring
* SNS Notifications
* Route53 Integration
* HTTPS using ACM Certificates
* Terraform Remote State (S3 + DynamoDB)
* CI/CD using GitHub Actions

---

## Author

**Sahil Dighe**

GitHub: https://github.com/sahil30dighe-web
