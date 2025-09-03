job "data-processor" {
  datacenters = ["dc1"]
  type = "batch"
  
  periodic {
    cron             = "0 */4 * * *"  // Run every 4 hours
    prohibit_overlap = true
  }

  group "processor" {
    count = 3

    task "process-data" {
      driver = "docker"
      
      config {
        image = "python:3.9-slim"
        command = "python"
        args = [
          "-c",
          "import time; print('Starting data processing job...'); time.sleep(60); print('Processing complete!')"
        ]
      }
      
      resources {
        cpu    = 500
        memory = 256
      }
      
      logs {
        max_files     = 10
        max_file_size = 10
      }
    }
  }
}