job "microservices-demo" {
  datacenters = ["dc1"]
  type = "service"

  group "frontend" {
    count = 2

    network {
      port "http" {
        to = 80
      }
    }

    service {
      name = "frontend"
      port = "http"
      tags = ["frontend", "web"]
      
      check {
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "webapp" {
      driver = "docker"
      
      config {
        image = "nginx:alpine"
        ports = ["http"]
        volumes = [
          "local/default.conf:/etc/nginx/conf.d/default.conf"
        ]
      }
      
      template {
        data = <<EOF
server {
    listen 80;
    server_name _;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }

    location /api {
        proxy_pass http://{{ range service "backend" }}{{ .Address }}:{{ .Port }}{{ end }};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /health {
        return 200 'healthy\n';
    }
}
EOF
        destination = "local/default.conf"
      }
      
      resources {
        cpu    = 300
        memory = 256
      }
    }
  }

  group "backend" {
    count = 3

    network {
      port "api" {
        to = 8080
      }
    }

    service {
      name = "backend"
      port = "api"
      tags = ["api", "backend"]
      
      check {
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "api-server" {
      driver = "docker"
      
      config {
        image = "node:16-alpine"
        ports = ["api"]
        command = "node"
        args = [
          "-e",
          "const http = require('http'); const server = http.createServer((req, res) => { if (req.url === '/health') { res.writeHead(200); res.end('healthy'); } else { res.writeHead(200, {'Content-Type': 'application/json'}); res.end(JSON.stringify({message: 'Hello from backend service', time: new Date().toISOString()})); } }); server.listen(8080);"
        ]
      }
      
      env {
        NODE_ENV = "production"
      }
      
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }

  group "cache" {
    count = 1

    network {
      port "redis" {
        to = 6379
      }
    }

    service {
      name = "cache"
      port = "redis"
      tags = ["cache", "redis"]
      
      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "redis" {
      driver = "docker"
      
      config {
        image = "redis:alpine"
        ports = ["redis"]
      }
      
      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}