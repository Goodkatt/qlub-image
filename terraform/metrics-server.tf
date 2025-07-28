resource "helm_release" "metrisc_server" {
    name       = "metrics-server"
    repository = "https://kubernetes-sigs.github.io/metrics-server"
    chart      = "metrics-server"
    version    = "3.12.2"
    namespace  = "kube-system"
    
    # set {
    #     name  = "args"
    #     value = "--kubelet-insecure-tls"
    # }
    set = [
        {
            name  = "containerPort"
            value = "10250"
        }
    ]
    depends_on = [ module.eks ]
}