resource "aws_iam_role" "cluster_autoscaler" {
    name = "CPMDemoClusterAutoscaler"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "sts:AssumeRole",
                    "sts:TagSession"
                ]
                Principal = {
                    Service = "pods.eks.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/k8s.io/cluster-autoscaler/enabled": "true",
                    "aws:ResourceTag/k8s.io/cluster-autoscaler/my-cluster": "owned"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:DescribeTags",
                "ec2:DescribeImages",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:GetInstanceTypesFromInstanceRequirements",
                "eks:DescribeNodegroup"
            ],
            "Resource": "*"
        }
    ]
    })
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_attachment" {
    policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
    role = aws_iam_role.cluster_autoscaler.name
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler_associate" {
    cluster_name = module.eks.cluster_name
    namespace = "kube-system"
    service_account = "cluster-autoscaler"
    role_arn = aws_iam_role.cluster_autoscaler.arn
}

resource "helm_release" "cluster_autoscaler_release" {
    name = "autoscaler"

    repository = "https://kubernetes.github.io/autoscaler"
    chart = "cluster-autoscaler"
    namespace = "kube-system"
    version = "9.46.6"


    set = [
        {
        name = "rbac.serviceAccount.name"
        value = "cluster-autoscaler"
        },
        {
            name = "autoDiscovery.clusterName"
            value = module.eks.cluster_name
        },
        {
            name = "awsRegion"
            value = "eu-west-1"
        }
    ]
    #depends_on = [ helm_release.metrics_server ]
    depends_on = [ module.eks ]
}

