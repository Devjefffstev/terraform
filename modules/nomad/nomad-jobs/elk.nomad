job "elk-stack" {
  datacenters = ["dc1"]
  type = "service"

  group "elasticsearch" {
    count = 1

    network {
      port "es_api" {
        to = 9200
      }
      port "es_nodes" {
        to = 9300
      }
    }

    service {
      name = "elasticsearch"
      port = "es_api"
      
      check {
        type     = "http"
        path     = "/_cluster/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    volume "elasticsearch-data" {
      type      = "host"
      read_only = false
      source    = "elasticsearch-data"
    }

    task "elasticsearch" {
      driver = "docker"
      
      config {
        image = "docker.elastic.co/elasticsearch/elasticsearch:7.17.0"
        ports = ["es_api", "es_nodes"]
        ulimit {
          nofile = "65536:65536"
        }
      }
      
      volume_mount {
        volume      = "elasticsearch-data"
        destination = "/usr/share/elasticsearch/data"
        read_only   = false
      }
      
      env {
        "ES_JAVA_OPTS" = "-Xms512m -Xmx512m"
        "discovery.type" = "single-node"
        "xpack.security.enabled" = "false"
        "xpack.monitoring.collection.enabled" = "true"
      }
      
      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }

  group "kibana" {
    count = 1

    network {
      port "kibana" {
        to = 5601
      }
    }

    service {
      name = "kibana"
      port = "kibana"
      
      check {
        type     = "http"
        path     = "/api/status"
        interval = "10s"
        timeout  = "2s"
      }
      
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.kibana.rule=Host(`kibana.nomad.local`)"
      ]
    }

    task "kibana" {
      driver = "docker"
      
      config {
        image = "docker.elastic.co/kibana/kibana:7.17.0"
        ports = ["kibana"]
      }
      
      template {
        data = <<EOH
server.name: kibana
server.host: "0"
elasticsearch.hosts: ["http://{{ range service "elasticsearch" }}{{ .Address }}:{{ .Port }}{{ end }}"]
monitoring.ui.container.elasticsearch.enabled: true
EOH
        destination = "local/kibana.yml"
        env = false
      }
      
      env {
        KIBANA_CONFIG = "/local/kibana.yml"
      }
      
      resources {
        cpu    = 500
        memory = 512
      }
    }
  }

  group "logstash" {
    count = 1

    network {
      port "beats" {
        to = 5044
      }
      port "http" {
        to = 9600
      }
    }

    service {
      name = "logstash"
      port = "beats"
      
      check {
        type     = "http"
        path     = "/_node/stats"
        interval = "10s"
        timeout  = "2s"
        port     = "http"
      }
    }

    task "logstash" {
      driver = "docker"
      
      config {
        image = "docker.elastic.co/logstash/logstash:7.17.0"
        ports = ["beats", "http"]
      }
      
      template {
        data = <<EOH
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][service] == "nomad" {
    grok {
      match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:loglevel}: %{GREEDYDATA:msg}" }
    }
    date {
      match => [ "timestamp", "ISO8601" ]
      target => "@timestamp"
    }
    mutate {
      rename => { "msg" => "message" }
    }
  }
}

output {
  elasticsearch {
    hosts => ["http://{{ range service "elasticsearch" }}{{ .Address }}:{{ .Port }}{{ end }}"]
    index => "%{[fields][service]}-%{+YYYY.MM.dd}"
  }
}
EOH
        destination = "local/pipeline/logstash.conf"
      }
      
      env {
        "LS_JAVA_OPTS" = "-Xms256m -Xmx256m"
      }
      
      resources {
        cpu    = 500
        memory = 768
      }
    }
  }

  group "filebeat" {
    count = 1

    network {
      port "filebeat_monitoring" {
        to = 5066
      }
    }

    service {
      name = "filebeat"
      port = "filebeat_monitoring"
      
      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "filebeat" {
      driver = "docker"
      
      config {
        image = "docker.elastic.co/beats/filebeat:7.17.0"
        ports = ["filebeat_monitoring"]
        
        volumes = [
          "/var/lib/nomad:/var/lib/nomad:ro",
          "/var/log:/var/log:ro"
        ]
      }
      
      template {
        data = <<EOH
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/*.log
    - /var/lib/nomad/alloc/*/alloc/logs/*.{log,stdout,stderr,out,err}
  fields:
    service: nomad

filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false

setup.ilm.enabled: false

output.logstash:
  hosts: ["{{ range service "logstash" }}{{ .Address }}:{{ .Port }}{{ end }}"]

logging.metrics.enabled: true
http.enabled: true
http.port: 5066
EOH
        destination = "local/filebeat.yml"
      }
      
      env {
        FILEBEAT_CONFIG_DIR = "/local"
      }
      
      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}