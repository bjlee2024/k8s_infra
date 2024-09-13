resource "aws_iam_role" "nodes" {
  name = "${var.env}-${var.region}-${var.name}-eks-nodes-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_nodes-policy" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ec2_container_registry_policy" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "general_ondemand_nodes" {
  cluster_name = aws_eks_cluster.eks.name
  version      = var.eks_version

  node_group_name = "general-ondemand-nodes-eks-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = module.vpc.private_subnets

  instance_types = var.instance_types

  scaling_config {
    desired_size = 3
    min_size     = 1
    max_size     = 5
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "OnDemand"
  }

  tags = {
    Environment = var.env
    Name        = "${var.env}-${var.region}-${var.name}-eks-nodes"
  }


}
