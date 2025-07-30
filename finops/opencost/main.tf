module "aws_eks" {
  source = "../../howtouse/aws/eks-cluster"
  # aws_access_key   = var.aws_access_key
  # aws_secret_key   = var.aws_secret_key
  eks_cluster_name   = "eks-opencost-${local.unique_value}"
  principal_arn_user = "arn:aws:iam::124345666311:user/jeffnoprod"
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
              enabled          = true
              refreshRateHours = 0.1
            }
          }
        })
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
            hostname         = "helloworld.aws.ociatepam.online"   # Replace with your domain
            hosts            = ["helloworld.aws.ociatepam.online"] # Replace with your domain
          }
        })
      ]
    }

  }
  depends_on = [kubernetes_storage_class_v1.main, module.pre_helm_charts]
}
module "pre_helm_charts" {
  source = "../../modules/general/helm"
  helm_releases = {
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

  }
  depends_on = [kubernetes_storage_class_v1.main]
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
  depends_on = [module.aws_eks]

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
      host = "opencost.nonprod.aws.ociatepam.online" # Replace with your domain

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
    rule {
      host = "opencost.aws.ociatepam.online" # Replace with your domain
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
  depends_on = [module.aws_eks, module.helm_charts]
}
## To configure OpenCost for your AWS account, create an Access Key for the OpenCost user who has access to the Cost and Usage Report (CUR)
resource "aws_iam_user" "opencost_user" {
  name = "opencost-user"
  path = "/"

}
resource "aws_iam_access_key" "opencost_user_key" {
  user = aws_iam_user.opencost_user.name
}
resource "aws_s3_bucket" "main" {
  bucket = "opencost-athena-query-results-${local.unique_value}"
  tags = {
    Name = "opencost-athena-query-results-${local.unique_value}"
  }
}
resource "aws_s3_bucket" "curcost" {
  bucket = "opencost-bucket-cur${local.unique_value}"
  tags = {
    Name = "opencost-bucket-cur-${local.unique_value}"
  }
}
resource "aws_s3_bucket_policy" "curcost_policy" {
  bucket = aws_s3_bucket.curcost.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = ["s3:PutObject"],
        Effect    = "Allow",
        Principal = { Service = "billingreports.amazonaws.com" },
        Resource  = "${aws_s3_bucket.curcost.arn}/*"
      },
      {
        Action    = ["s3:GetBucketAcl"],
        Effect    = "Allow",
        Principal = { Service = "billingreports.amazonaws.com" },
        Resource  = "${aws_s3_bucket.curcost.arn}"
      }
    ]
  })
}
resource "aws_iam_user_policy" "opencost-cur-access-policy" {
  name   = "opencost_policy"
  user   = aws_iam_user.opencost_user.name
  policy = data.aws_iam_policy_document.opencost-cur-access-policy.json
}


# resource "aws_athena_database" "main" {
#   name   = "opencostathenadb"
#   bucket = aws_s3_bucket.main.id
# }

# output "athena_database" {
#   value     = aws_athena_database.main
#   sensitive = true

# }

# ###########
# resource "aws_kms_key" "test" {
#   deletion_window_in_days = 7
#   description             = "Athena KMS Key"
# }
# resource "aws_athena_workgroup" "test" {
#   name = "opencost-athena-workgroup"

#   configuration {
#     result_configuration {
#       encryption_configuration {
#         encryption_option = "SSE_KMS"
#         kms_key_arn       = aws_kms_key.test.arn
#       }
#     }
#   }
# }
# resource "aws_athena_named_query" "create_table" {
#   name        = "CreateOpenCostTable"
#   database    = aws_athena_database.main.name
#   workgroup   = aws_athena_workgroup.test.id
#   description = "Creates an OpenCost table in Athena database"
#   query       = <<EOT
# CREATE EXTERNAL TABLE IF NOT EXISTS `${aws_athena_database.main.name}`.`opencost_table` (`bill_invoice_id` string, `bill_invoicing_entity` int)
# ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
# WITH SERDEPROPERTIES ('field.delim' = ',')
# STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
# LOCATION 's3://${aws_s3_bucket.main.id}/result-query/'
# TBLPROPERTIES ('classification' = 'csv');
# EOT
# }
# resource "terraform_data" "run_existing_query" {
#   count = var.deleteFlag ? 0 : 1
#   provisioner "local-exec" {
#     command = <<EOT
#       aws athena start-query-execution \
#         --query-string "$(aws athena get-named-query --named-query-id ${aws_athena_named_query.create_table.id} --output text --query 'NamedQuery.QueryString')" \
#         --query-execution-context Database=${aws_athena_database.main.id} \
#         --result-configuration OutputLocation='s3://${aws_s3_bucket.main.id}/result-query/'
#     EOT
#   }
#   depends_on = [aws_athena_database.main, aws_athena_named_query.create_table]
# }


### CUR report 
resource "aws_cur_report_definition" "example_cur_report_definition" {
  report_name                = "opencost-cur-report-definition"
  time_unit                  = "HOURLY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES", "SPLIT_COST_ALLOCATION_DATA"]
  s3_bucket                  = aws_s3_bucket.curcost.id
  s3_prefix                  = "example-cur-report"
  s3_region                  = "us-east-1"
  report_versioning          = "OVERWRITE_REPORT"
  additional_artifacts       = ["ATHENA"]
  depends_on                 = [aws_s3_bucket.curcost, aws_iam_user_policy.opencost-cur-access-policy]
}

resource "kubernetes_secret_v1" "aws_secret" {
  metadata {
    name      = "cloud-costs" #Keep this name consistent with the HELM OpenCost configuration
    namespace = "opencost"    # Change to the target namespace if necessary
  }

  data = {
    "cloud-integration.json" = templatefile("${path.module}/cloud-integration.json.tpl", {
      bucket            = "s3://${aws_s3_bucket.main.id}/queryresults/"
      region            = aws_s3_bucket.main.region
      database          = "athenacurcfn_opencost_cur_report_definition"
      table             = "opencost_cur_report_definition"
      workgroup         = "primary"
      account           = data.aws_caller_identity.current.account_id
      authorizer_type   = "AWSAccessKey"
      access_key_id     = "${aws_iam_access_key.opencost_user_key.id}"
      secret_access_key = "${aws_iam_access_key.opencost_user_key.secret}"
    })
  }

  type = "Opaque"
}
