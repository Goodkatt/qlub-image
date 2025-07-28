resource "aws_iam_role" "eks_worker_role" {
    name = "CPMDemoWorkerRole"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_policy" "worker_ecr_ro_policy" {
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings"
            ],
            "Resource": "*"
        }
    ]
    })
}
resource "aws_iam_policy" "worker_cni_policy" {
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AmazonEKSCNIPolicy",
            "Effect": "Allow",
            "Action": [
                "ec2:AssignPrivateIpAddresses",
                "ec2:AttachNetworkInterface",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeSubnets",
                "ec2:DetachNetworkInterface",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AmazonEKSCNIPolicyENITag",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:network-interface/*"
            ]
        }
    ]
    })
}
resource "aws_iam_policy" "worker_node_policy" {
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "WorkerNodePermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumesModifications",
                "ec2:DescribeVpcs",
                "eks:DescribeCluster",
                "eks-auth:AssumeRoleForPodIdentity"
            ],
            "Resource": "*"
        }
    ]
    })
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachemnt" {
    policy_arn = aws_iam_policy.worker_ecr_ro_policy.arn
    role = aws_iam_role.eks_worker_role.name
}
resource "aws_iam_role_policy_attachment" "cni_policy_attachment" {
    policy_arn = aws_iam_policy.worker_cni_policy.arn
    role = aws_iam_role.eks_worker_role.name
}
resource "aws_iam_role_policy_attachment" "node_policy_attachment" {
    policy_arn = aws_iam_policy.worker_node_policy.arn
    role = aws_iam_role.eks_worker_role.name
}
# resource "aws_iam_role_policy_attachment" "cni_policy_attachment_two" {
#     policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#     role = aws_iam_role.eks_worker_role.name
# }