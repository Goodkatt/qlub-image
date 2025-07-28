output "secret_arm" {
    value = module.secret_key.secret_arn
}
output "policy_arn" {
    value = aws_iam_policy.alb_controller_policy.arn
  
}
output "cluster_name" {
    value = module.eks.cluster_name
}
output "vpc_id" {
    value = module.vpc.vpc_id
  
}
output "secre_access_policy_arn" {
    value = aws_iam_policy.secre_access_policy.arn
  
}