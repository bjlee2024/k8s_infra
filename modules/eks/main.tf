# Purpose: Create EKS cluster
# Created by byeongjin lee

resource "aws_iam_role" "eks" {
  name = "${var.env}-${var.region}-${var.name}-eks-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-policy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks" {
  depends_on = [aws_iam_role_policy_attachment.eks-policy]

  name     = "${var.env}-${var.region}-${var.name}-eks-cluster"
  role_arn = aws_iam_role.eks.arn
  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false


    subnet_ids = module.vpc.private_subnet_ids
  }

  access_config {
    # https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/auth-configmap.html
    # aws-auth ConfigMap is deprecated, use the Kubernetes API to manage RBAC permissions.
    authentication_mode = "API"
    # we wll use helm chart or k8s yaml resource to deploy
    # so we don't need to create a bootstrap user and this wuold be false in production
    bootstrap_cluster_creator_admin_permissions = true
  }
}

