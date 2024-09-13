# Purpose: Create the EKS node group
# Created by byeongjin lee

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

resource "aws_iam_role_policy_attachment" "eks_worker_nodes_policy" {
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

resource "aws_eks_node_group" "general_on_demand" {
  # "has not been declared in module.eks." is popped up when using the below code
  # i'm not sure why it's happening ㅋㅋ
  # # depends_on = [
  #   aws_ima_role_policy_attachment.eks_worker_nodes_policy,
  #   aws_ima_role_policy_attachment.eks_cni_policy,
  #   aws_ima_role_policy_attachment.eks_ec2_container_registry_policy,
  # ]

  cluster_name = aws_eks_cluster.eks.name
  version      = var.eks_version

  node_group_name = "general-ondemand-nodes-eks-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  # it's better to use private subnets for the nodes
  # and it should be in different AZs, at least 2
  # actually we will use 3 private subnets for each different azs
  subnet_ids = var.private_subnet_ids

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-purchasing-options.html
  # default for purchasing option is "ON_DEMAND"
  capacity_type  = "ON_DEMAND"
  instance_types = var.instance_types

  # 
  scaling_config {
    # actually it won't be used except for the initial
    # we will use an additional component(karpenter) to manage the node autoscaling
    desired_size = 3
    min_size     = 1
    max_size     = 5
  }

  # https://docs.aws.amazon.com/eks/latest/userguide/managed-node-update-behavior.html
  # at least 1 node should be available during the upgrade process
  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "OnDemand"
  }

  tags = {
    Name = "${var.env}-${var.region}-${var.name}-eks-nodes"
  }

  # refer the above comment
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
