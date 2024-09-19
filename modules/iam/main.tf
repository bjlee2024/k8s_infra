## IAM module for EKS
## Created by byeongjin lee

# Purpose: Create IAM resources for EKS 
#          Create Kubernetes cluster role
#          Biding IAM role and Kubernetes cluster role


# Section : Developer
# support access entry with IAM user or IAM role
resource "aws_iam_user" "developer_eks" {
  name = "developer_eks"
}

resource "aws_iam_policy" "developer_eks" {
  name = "AmazonEKSDeveloperPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "developer_eks" {
  user       = aws_iam_user.developer_eks.name
  policy_arn = aws_iam_policy.developer_eks.arn
}

# In case of using IAM user, To access EKS cluster
resource "aws_eks_access_entry" "developer" {
  cluster_name      = var.eks_name
  principal_arn     = aws_iam_user.developer_eks.arn
  kubernetes_groups = ["eks-developer-from-iam-user"]
}

resource "aws_iam_role" "developer_eks" {
  name               = "eks-developer-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "developer_eks_assume" {
  name = "AmazonEKSDeveloperAssumePolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = "*",
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "eks.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_developer" {
  role       = aws_iam_role.developer_eks.name
  policy_arn = aws_iam_policy.developer_eks_assume.arn
}


# In case of using Role, To access EKS cluster as developer
resource "aws_eks_access_entry" "developer_role" {
  cluster_name      = var.eks_name
  principal_arn     = aws_iam_role.developer_eks.arn
  kubernetes_groups = ["eks-developer-from-iam-role"]
}

## Admin IAM role for EKS
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eks_admin" {
  name = "eks-admin"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "eks_admin" {
  name = "AmazonEKSAdminAssumePolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

resource "aws_iam_user" "eks_admin" {
  name = "eks_admin"
}

resource "aws_iam_policy" "eks_assume_admin" {
  name = "AmazonEKSAssumeAdminPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "${aws_iam_role.eks_admin.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "eks_admin" {
  user       = aws_iam_user.eks_admin.name
  policy_arn = aws_iam_policy.eks_assume_admin.arn
}

# In case of using Role, To access EKS cluster as admin
resource "aws_eks_access_entry" "eks_admin" {
  cluster_name      = var.eks_name
  principal_arn     = aws_iam_role.eks_admin.arn
  kubernetes_groups = ["eks-admin"]
}


