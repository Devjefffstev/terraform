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
      #     extraScrapeConfigs: |
      # - job_name: opencost
      #   honor_labels: true
      #   scrape_interval: 1m
      #   scrape_timeout: 10s
      #   metrics_path: /metrics
      #   scheme: http
      #   dns_sd_configs:
      #   - names:
      #     - opencost.opencost
      #     type: 'A'
      #     port: 9003
      values = [
        yamlencode({
          alertmanager = {
            enabled = false
          }
          prometheus-pushgateway = {
            enabled = false
          }
          extraScrapeConfigs = <<-EOT
            - job_name: opencost
              honor_labels: true
              scrape_interval: 1m
              scrape_timeout: 10s
              metrics_path: /metrics
              scheme: http
              dns_sd_configs:
              - names:
                - opencost.opencost
                type: 'A'
                port: 9003
          EOT
        })
      ]
    }
    opencost = {
      chart            = "opencost"
      repository       = "https://opencost.github.io/opencost-helm-chart"
      namespace        = "opencost"
      create_namespace = true
      values = [
        yamlencode({
          opencost = {
            cloudIntegrationSecret = "cloud-costs"
            cloudCost = {
              enabled = true
            }
          }
        })
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
            enabled          = true
            path             = "/"
            ingressClassName = "nginx"
            hostname         = "helloworld.opencost.cosmoinc.online"   # Replace with your domain
            hosts            = ["helloworld.opencost.cosmoinc.online"] # Replace with your domain
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

## To configure OpenCost for your AWS account, create an Access Key for the OpenCost user who has access to the Cost and Usage Report (CUR)
resource "aws_iam_user" "opencost_user" {
  name = "opencost-user"
  path = "/"
}

resource "aws_iam_access_key" "opencost_user_key" {
  user = aws_iam_user.opencost_user.name
}
output "opencost_user_key" {
  value     = aws_iam_access_key.opencost_user_key
  sensitive = true

}

resource "aws_s3_bucket" "main" {
  bucket = "aws-athena-query-results-${module.aws_eks.cluster_eks.eks_properties.id}"
  tags = {
    Name = "opencost"
  }
}
output "aws_s3_bucket" {
  value     = aws_s3_bucket.main
  sensitive = true

}

resource "aws_athena_database" "main" {
  name   = "opencostathenadb"
  bucket = aws_s3_bucket.main.id
}

output "athena_database" {
  value     = aws_athena_database.main
  sensitive = true

}

###########
resource "aws_kms_key" "test" {
  deletion_window_in_days = 7
  description             = "Athena KMS Key"
}
resource "aws_athena_workgroup" "test" {
  name = "opencost-athena-workgroup"

  configuration {
    result_configuration {
      encryption_configuration {
        encryption_option = "SSE_KMS"
        kms_key_arn       = aws_kms_key.test.arn
      }
    }
  }
}
resource "aws_athena_named_query" "create_table" {
  name        = "CreateOpenCostTable"
  database    = aws_athena_database.main.name
  workgroup = aws_athena_workgroup.test.id  
  description = "Creates an OpenCost table in Athena database"
  query       = <<EOT
CREATE EXTERNAL TABLE IF NOT EXISTS `opencostathenadb`.`opencost_table` (`column1` string, `column2` int)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION 's3://aws-athena-query-results-eks-cluster-opencost-cost/opencostobject/'
TBLPROPERTIES (
  'classification' = 'parquet',
  'parquet.compression' = 'SNAPPY'
);
EOT
}
resource "null_resource" "run_existing_query" {
  provisioner "local-exec" {
    command = <<EOT
      aws athena start-query-execution \
        --query-string "$(aws athena get-named-query --named-query-id ${aws_athena_named_query.create_table.id} --output text --query 'NamedQuery.QueryString')" \
        --query-execution-context Database=${aws_athena_database.main.id} \
        --result-configuration OutputLocation='s3://${aws_s3_bucket.main.id}/query-results/'
    EOT
  }

  depends_on = [aws_athena_database.main, aws_athena_named_query.create_table]
}