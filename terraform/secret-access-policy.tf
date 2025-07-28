resource "aws_iam_policy" "secre_access_policy" {
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret"
                ],
                "Resource": [
                    module.secret_key.secret_arn,
                    module.debug.secret_arn,
                    module.databasename.secret_arn,
                    module.databaseuser.secret_arn,
                    module.databaspassword.secret_arn,
                    module.databashost.secret_arn,
                    module.databasport.secret_arn
                ]
            }
        ]
    })
  
}