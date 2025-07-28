resource "aws_iam_role" "read_dynamo_db" {
    name = "CPMDemoReadFromDynamoDB"

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

resource "aws_iam_policy" "dynamo_db_full_access" {
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GeneralReadOnlyAccess",
            "Action": [
                "application-autoscaling:DescribeScalableTargets",
                "application-autoscaling:DescribeScalingActivities",
                "application-autoscaling:DescribeScalingPolicies",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "datapipeline:DescribeObjects",
                "datapipeline:DescribePipelines",
                "datapipeline:GetPipelineDefinition",
                "datapipeline:ListPipelines",
                "datapipeline:QueryObjects",
                "dynamodb:BatchGetItem",
                "dynamodb:Describe*",
                "dynamodb:List*",
                "dynamodb:GetAbacStatus",
                "dynamodb:GetItem",
                "dynamodb:GetResourcePolicy",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:PartiQLSelect",
                "dax:Describe*",
                "dax:List*",
                "dax:GetItem",
                "dax:BatchGetItem",
                "dax:Query",
                "dax:Scan",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "iam:GetRole",
                "iam:ListRoles",
                "kms:DescribeKey",
                "kms:ListAliases",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "lambda:ListFunctions",
                "lambda:ListEventSourceMappings",
                "lambda:GetFunctionConfiguration",
                "resource-groups:ListGroups",
                "resource-groups:ListGroupResources",
                "resource-groups:GetGroup",
                "resource-groups:GetGroupQuery",
                "tag:GetResources",
                "kinesis:ListStreams",
                "kinesis:DescribeStream",
                "kinesis:DescribeStreamSummary"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "CCIAccess",
            "Action": "cloudwatch:GetInsightRuleReport",
            "Effect": "Allow",
            "Resource": "arn:aws:cloudwatch:*:*:insight-rule/DynamoDBContributorInsights*"
        }
    ]
    })
}

resource "aws_iam_policy" "s3_full_access" {
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
    })
}

resource "aws_iam_role_policy_attachment" "dynamo_db_attachment" {
    policy_arn = aws_iam_policy.dynamo_db_full_access.arn
    role = aws_iam_role.read_dynamo_db.name
}
resource "aws_iam_role_policy_attachment" "s3_attachment" {
    policy_arn = aws_iam_policy.s3_full_access.arn
    role = aws_iam_role.read_dynamo_db.name
}

# resource "aws_eks_pod_identity_association" "dynamo_db_associate" {
#     cluster_name = module.eks.cluster_name
#     namespace = "test-ns"
#     service_account = "dev-sa2"
#     role_arn = aws_iam_role.read_dynamo_db.arn
# }