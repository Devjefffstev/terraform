job "prometheus" {
    datacenters = ["dc1"]
    type = "service"
  
    group "monitoring" {
      count = 1
  
      network {
        port "prometheus_ui" {
          static = 9090
          to     = 9090
        }
      }
  
      service {
        name = "prometheus"
        port = "prometheus_ui"
        
        check {
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
  
      task "prometheus" {
        driver = "docker"
        
        config {
          image = "prom/prometheus:latest"
          ports = ["prometheus_ui"]
          
          volumes = [
            "local/prometheus.yml:/etc/prometheus/prometheus.yml"
          ]
        }
        
        template {
          data = <<EOH
  global:
    scrape_interval:     15s
    evaluation_interval: 15s
  
  scrape_configs:
    - job_name: 'nomad_metrics'
      metrics_path: /v1/metrics
      params:
        format: ['prometheus']
      static_configs:
        - targets: ['{{ env "attr.unique.network.ip-address" }}:4646']
  EOH
          destination = "local/prometheus.yml"
        }
        
        resources {
          cpu    = 500
          memory = 512
        }
      }
    }
  }