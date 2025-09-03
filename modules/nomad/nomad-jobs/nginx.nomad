
I'm working on demoing nomad cluster please prepare couple of definitions for samples containers I can run there

I'd be happy to help you with sample container definitions for a Nomad cluster. Nomad is a flexible workload orchestrator that can deploy a diverse set of applications including Docker containers, and it's a good alternative to Kubernetes in many scenarios.

Here are a few sample Nomad job specifications you can use for your demo:


Nginx Web Server
Code 

Redis Cache Service
Code 

Prometheus Monitoring
Code 
These three Nomad job specifications provide a good starting point for your demo:

Nginx Web Server: A simple web server with two instances for high availability and automatic h



job "nginx" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {
    count = 2

    network {
      port "http" {
        to = 80
      }
    }

    service {
      name = "nginx"
      port = "http"
      
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "nginx" {
      driver = "docker"
      
      config {
        image = "nginx:latest"
        ports = ["http"]
      }
      
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
