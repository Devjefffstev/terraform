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
  #   #helm install prometheus --repo https://prometheus-community.github.io/helm-charts prometheus \
  #   --namespace prometheus-system --create-namespace \
  #   --set prometheus-pushgateway.enabled=false \
  #   --set alertmanager.enabled=false \
  #   -f https://raw.githubusercontent.com/opencost/opencost/develop/kubernetes/prometheus/extraScrapeConfigs.yaml
  # youu will create a helm_release for prometheus
  helm_releases = {
    "prometheus" = {
      chart      = "prometheus"
      repository = "https://prometheus-community.github.io/helm-charts"
      namespace  = "prometheus-system"
      #(List of String) List of values in raw yaml format to pass to helm.
      values = [
        <<-EOT
          alertmanager:
            enabled: false
          pushgateway:
            enabled: false
        EOT
      ]
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
  }
  depends_on = [module.aws_eks, ]
}

resource "kubernetes_storage_class_v1" "main" {
  # Matches the provisioner in the YAML definition
  storage_provisioner = "ebs.csi.eks.amazonaws.com"

  # Same volume binding mode defined via YAML
  volume_binding_mode = "WaitForFirstConsumer"

  # Set the parameters for the StorageClass
  parameters = {
    type      = "gp3"            # Storage will use gp3 type
    encrypted = "true"           # Ensure encryption is enabled
  }

  # Metadata for the StorageClass, including name and annotations
  metadata {
    name = "auto-ebs-sc"    # New StorageClass name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true" # Don't make this default
    }
  }
}