# Creating an IAM role that will be assumed by the EBS driver
resource "aws_iam_role" "ebs_csi_role" {
  name = "${var.tags["Name"]}-${var.tags["Environment"]}-ebs-csi-driver"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

# Attaching the AWS managed policy for the EBS CSI driver to the role
resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_role.name
}

# Deploying the EBS addon
resource "aws_eks_addon" "ebs_csi" {
  cluster_name = data.aws_eks_cluster.eks.name
  addon_name   = "aws-ebs-csi-driver"

  addon_version = data.aws_eks_addon_version.ebs_csi_136.version

  resolve_conflicts_on_update = "PRESERVE"


  depends_on = [aws_eks_pod_identity_association.ebs_csi]
}

# Associating the IAM role to be assumed with the teh EKS add on service account
resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = data.aws_eks_cluster.eks.name
  service_account = "ebs-csi-controller-sa"
  namespace       = "kube-system"
  role_arn        = aws_iam_role.ebs_csi_role.arn
}
