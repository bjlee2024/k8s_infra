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
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

