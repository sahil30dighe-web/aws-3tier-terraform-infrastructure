# AWS 3-Tier Infrastructure using Terraform (IaC)

## Project Overview

This project demonstrates the deployment of a production-style AWS infrastructure using Terraform (Infrastructure as Code). The infrastructure follows a multi-tier architecture design with separate networking, security, compute, and load balancing layers. All resources are provisioned and managed through Terraform configuration files, enabling repeatable and automated deployments.

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
(App Servers)
    │
    ▼
Private Database Tier
(Database Subnets Ready for RDS)
```

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

### Security & IAM

* IAM Users
* IAM Groups
* IAM Roles
* IAM Policies
* MFA Enforcement Policy
* Security Groups

### Compute

* EC2 Launch Template
* Auto Scaling Group
* User Data Scripts

### Load Balancing

* Application Load Balancer (ALB)
* Target Group
* Health Checks

## Features

* Infrastructure as Code (Terraform)
* Multi-AZ Deployment
* Public and Private Network Segmentation
* Secure IAM Configuration
* Auto Scaling for High Availability
* Load Balanced Application Traffic
* Layered Security Group Architecture
* Automated Web Server Deployment

## Security Architecture

### ALB Security Group

* Allows HTTP (80)
* Allows HTTPS (443)

### Application Security Group

* Allows traffic only from ALB Security Group

### Database Security Group

* Allows MySQL (3306) traffic only from Application Security Group

## IAM Implementation

### Groups

* Admins
* Developers
* Finance

### Policies

* AdministratorAccess
* PowerUserAccess
* Billing Access
* RDS Protection Policy
* MFA Enforcement Policy

### Roles

* EC2 Role
* S3 ReadOnly Access
* CloudWatch Agent Access

## Deployment Steps

### Initialize Terraform

```bash
terraform init
```

### Validate Configuration

```bash
terraform validate
```

### Review Infrastructure Changes

```bash
terraform plan
```

### Deploy Infrastructure

```bash
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

## Project Structure

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
└── README.md
```

## Skills Demonstrated

* AWS Cloud Infrastructure
* Terraform
* Infrastructure as Code (IaC)
* Networking Design
* IAM & Security Best Practices
* Auto Scaling
* Load Balancing
* Git & GitHub
* Linux Administration

## Future Enhancements

* Amazon RDS Integration
* CloudWatch Monitoring
* SNS Notifications
* Route53 Domain Integration
* HTTPS using ACM Certificates
* CI/CD Pipeline with GitHub Actions
* Remote Terraform State using S3 and DynamoDB

## Author

**Sahil Dighe**

GitHub: https://github.com/sahil30dighe-web

