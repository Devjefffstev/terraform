job "postgres" {
  datacenters = ["dc1"]
  type = "service"

  group "database" {
    count = 1

    network {
      port "db" {
        to = 5432
      }
    }

    volume "postgres" {
      type      = "host"
      read_only = false
      source    = "postgres"
    }

    service {
      name = "postgres"
      port = "db"
      
      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "postgres" {
      driver = "docker"
      
      config {
        image = "postgres:14"
        ports = ["db"]
      }

      volume_mount {
        volume      = "postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }
      
      env {
        POSTGRES_USER = "nomad"
        POSTGRES_PASSWORD = "nomadpassword"
        POSTGRES_DB = "nomaddb"
      }
      
      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}