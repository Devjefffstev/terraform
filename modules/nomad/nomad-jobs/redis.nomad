job "redis" {
    datacenters = ["dc1"]
    type = "service"
  
    group "cache" {
      count = 1
  
      network {
        port "redis" {
          to = 6379
        }
      }
  
      service {
        name = "redis-cache"
        port = "redis"
        
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
  
      task "redis" {
        driver = "docker"
        
        config {
          image = "redis:7-alpine"
          ports = ["redis"]
        }
        
        resources {
          cpu    = 500
          memory = 256
        }
      }
    }
  }