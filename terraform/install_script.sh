 #!/bin/bash



# export TF_VAR_secret_key="my-super-secret-password"
# export TF_VAR_debug="true"
# export TF_VAR_database_name="pg-sql"
# export TF_VAR_database_user="pg-user"
# export TF_VAR_database_password="pg-admin"
# export TF_VAR_database_host="localhost"
# export TF_VAR_database_port="5432"



terraform apply --auto-approve

aws eks update-kubeconfig --region eu-west-1 --name my-cluster
POLICY_ARN=$(terraform output -raw policy_arn)
CLUSTER_NAME=$(terraform output -raw cluster_name)
VPC_ID=$(terraform output -raw vpc_id)


eksctl create iamserviceaccount \
    --cluster="$CLUSTER_NAME" \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn="$POLICY_ARN" \
    --override-existing-serviceaccounts \
    --region eu-west-1 \
    --approve


helm repo add eks https://aws.github.io/eks-charts || true
helm repo update

# helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
#   -n kube-system \
#   --set clusterName="$CLUSTER_NAME" \
#   --set serviceAccount.create=false \
#   --set serviceAccount.name=aws-load-balancer-controller \
#   --set vpcId="$VPC_ID" \
#   --version 1.13.0
if helm status aws-load-balancer-controller -n kube-system > /dev/null 2>&1; then
  echo "Helm release already exists. Skipping install."
else
  helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName="$CLUSTER_NAME" \
    --set serviceAccount.create=false \
    --set serviceAccount.name=aws-load-balancer-controller \
    --set vpcId="$VPC_ID" \
    --version 1.13.0
fi


kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# helm repo add argo https://argoproj.github.io/argo-helm
# helm install argocd-demo argo/argo-cd -f argocd-custom-values.yml

#kubectl port-forward svc/argocd-server -n argocd 8080:443
#kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath={.data.password} | base64 -d

eksctl create iamserviceaccount \
        --name ebs-csi-controller-sa \
        --namespace kube-system \
        --cluster my-cluster \
        --role-name AmazonEKS_EBS_CSI_DriverRole \
        --role-only \
        --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
        --region eu-west-1 \
        --approve

helm install my-postgres oci://registry-1.docker.io/bitnamicharts/postgresql \                                                                                                                                                                                                          ─╯
  --namespace default \
  --create-namespace \
  --set primary.persistence.storageClass=encrypted

#######! Important Note !#######
# The following command is used to install the EBS CSI driver.
# Update the hop count in imds to 2 to avoid the error "Unable to connect to the IMDS endpoint".
# This is done to ensure that the EBS CSI driver can communicate with the instance metadata service


eksctl create iamserviceaccount \
                --region=eu-west-1 --namespace default --name eks-secrets-sa \
                --cluster my-cluster \
                --attach-policy-arn  arn:aws:iam::023703779142:policy/terraform-20250727115122996000000001 --approve \
                --override-existing-serviceaccounts


#psql -h localhost -U postgres -d postgres
# Şifre: ZQpysSislb
# argo 70bV-eoU6KjPlNdR

aws ecr get-login-password \
     --region eu-west-1 | helm registry login \
     --username AWS \
     --password-stdin 023703779142.dkr.ecr.eu-west-1.amazonaws.com

helm push django-app-0.1.0.tgz oci://023703779142.dkr.ecr.eu-west-1.amazonaws.com/

argocd login localhost:8080 --username admin --password 70bV-eoU6KjPlNdR
argocd repo add 023703779142.dkr.ecr.eu-west-1.amazonaws.com --type helm --name qlub-helm-repo --enable-oci --username AWS --password $(aws ecr get-login-password --region eu-west-1)

git fetch origin
git rebase origin/main