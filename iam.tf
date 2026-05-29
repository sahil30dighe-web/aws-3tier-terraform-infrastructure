#IAM
resource "aws_iam_group" "admins" {
  name = "Admins"
}

resource "aws_iam_group" "developers" {
  name = "Developers"
}

resource "aws_iam_group" "finance" {
  name = "Finance"
}

#IAM Users
resource "aws_iam_user" "employee1" {
  name = "admin-user"
}

resource "aws_iam_user" "employee2" {
  name = "dev-user-1"
}

resource "aws_iam_user" "employee3" {
  name = "dev-user-2"
}

resource "aws_iam_user" "employee4" {
  name = "finance-user-1"
}

resource "aws_iam_user" "employee5" {
  name = "finance-user-2"
}

#IAM Group Memberships

resource "aws_iam_user_group_membership" "admin_membership" {

  user = aws_iam_user.employee1.name

  groups = [
    aws_iam_group.admins.name
  ]
}

resource "aws_iam_user_group_membership" "dev1_membership" {

  user = aws_iam_user.employee2.name

  groups = [
    aws_iam_group.developers.name
  ]
}

resource "aws_iam_user_group_membership" "dev2_membership" {

  user = aws_iam_user.employee3.name

  groups = [
    aws_iam_group.developers.name
  ]
}

resource "aws_iam_user_group_membership" "finance1_membership" {

  user = aws_iam_user.employee4.name

  groups = [
    aws_iam_group.finance.name
  ]
}

resource "aws_iam_user_group_membership" "finance2_membership" {

  user = aws_iam_user.employee5.name

  groups = [
    aws_iam_group.finance.name
  ]
}

#IAM Policies
resource "aws_iam_group_policy_attachment" "admins_policy" {

  group = aws_iam_group.admins.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "developers_policy" {

  group = aws_iam_group.developers.name

  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_group_policy_attachment" "finance_policy" {

  group = aws_iam_group.finance.name

  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

#IAM Roles
resource "aws_iam_role" "ec2_role" {

  name = "ShopEase-EC2-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

#RDS Protection policy
resource "aws_iam_policy" "rds_protection_policy" {

  name = "RDS-Protection-Policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Deny"

        Action = [
          "rds:DeleteDBInstance",
          "rds:DeleteDBCluster"
        ]

        Resource = "*"
      }
    ]
  })
}
#IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ec2_s3" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

#IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {

  name = "ShopEase-EC2-Profile"

  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_group_policy_attachment" "developers_rds_protection" {

  group = aws_iam_group.developers.name

  policy_arn = aws_iam_policy.rds_protection_policy.arn
}

#MFA
resource "aws_iam_policy" "mfa_policy" {

  name = "Require-MFA"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Deny"

        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "sts:GetSessionToken"
        ]

        Resource = "*"

        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "admins_mfa" {

  group = aws_iam_group.admins.name

  policy_arn = aws_iam_policy.mfa_policy.arn
}
