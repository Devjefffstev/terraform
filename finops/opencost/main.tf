resource "random_string" "random" {
  length           = 4
  special          = true
  override_special = "/@£$"
}
module "aws_eks" {
  source         = "../../howtouse/aws/eks-automode"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key

}
output "aws_eks" {
  value = module.aws_eks.cluster_eks.eks_properties
}
module "helm_charts" {
  source = "../../modules/general/helm"
  helm_releases = {
    "prometheus" = {
      chart      = "prometheus"
      repository = "https://prometheus-community.github.io/helm-charts"
      namespace  = "prometheus-system"
      values = [
        yamlencode({
          alertmanager = {
            enabled = false
          }
          prometheus-pushgateway = {
            enabled = false
          }
        })
      ]
    }
    opencost = {
      chart            = "opencost"
      repository       = "https://opencost.github.io/opencost-helm-chart"
      namespace        = "opencost"
      create_namespace = true

    }
    nginx-ingress-controller = {
      chart            = "ingress-nginx"
      repository       = "https://kubernetes.github.io/ingress-nginx"
      namespace        = "ingress-nginx"
      create_namespace = true
      values = [
        <<-EOT
          controller:
            service:
              enabled: true
              type: LoadBalancer
        EOT
      ]
    }
    ## helloworld basic application with ingress 
    helloworld = {
      chart            = "nginx"
      repository       = "https://charts.bitnami.com/bitnami"
      namespace        = "nginx-helloworld"
      create_namespace = true
      values = [
        yamlencode({
          service = {
            type = "ClusterIP"
          }
          ingress = {
            enabled = true
            path    = "/"
            ingressClassName = "nginx"
            hostname = "helloworld.opencost.cosmoinc.online" # Replace with your domain
            hosts   = ["helloworld.opencost.cosmoinc.online"] # Replace with your domain
          }
        })
      ]
    }
    
  }
  depends_on = [kubernetes_storage_class_v1.main]
}

output "helm_charts" {
  value     = module.helm_charts
  sensitive = true

}

resource "kubernetes_storage_class_v1" "main" {
  # Matches the provisioner in the YAML definition
  storage_provisioner = "ebs.csi.aws.com"

  # Same volume binding mode defined via YAML
  volume_binding_mode = "WaitForFirstConsumer"

  # Set the parameters for the StorageClass
  parameters = {
    type      = "gp3"  # Storage will use gp3 type
    encrypted = "true" # Ensure encryption is enabled
  }

  # Metadata for the StorageClass, including name and annotations
  metadata {
    name = "ebs-sc" # New StorageClass name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true" # Don't make this default
    }
  }
}

resource "kubernetes_ingress_v1" "opencost" {
  metadata {
    name      = "open-cost-ingress"
    namespace = "opencost"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {   
    ingress_class_name = "nginx"
    rule {
      host = "opencost.cosmoinc.online" # Replace with your domain
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "opencost"
              port {
                name = "http-ui"
              }
            }
          }
        }
      }
    }
  }

}
