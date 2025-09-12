job "traefik" {
  datacenters = ["dc1"]
  type = "service"

  group "traefik" {
    count = 1

    network {
      port "http" {
        static = 80
      }
      port "https" {
        static = 443
      }
      port "admin" {
        static = 8080
      }
    }

    service {
      name = "traefik"
      port = "http"
      
      check {
        type     = "http"
        path     = "/ping"
        interval = "10s"
        timeout  = "2s"
        port     = "admin"
      }
    }

    task "traefik" {
      driver = "docker"
      
      config {
        image = "traefik:v2.9"
        ports = ["http", "https", "admin"]
        volumes = [
          "local/traefik.yaml:/etc/traefik/traefik.yaml"
        ]
      }
      
      template {
        data = <<EOH
entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"
  traefik:
    address: ":8080"

api:
  dashboard: true
  insecure: true

providers:
  consulCatalog:
    prefix: "traefik"
    exposedByDefault: false
    defaultRule: "Host(`{{ .Name }}.nomad.local`)"
    endpoint:
      address: "{{ env "attr.unique.network.ip-address" }}:8500"
      scheme: "http"

log:
  level: "INFO"
EOH
        destination = "local/traefik.yaml"
      }
      
      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}