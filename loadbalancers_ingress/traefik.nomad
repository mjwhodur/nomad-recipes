job "lb" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "traefik" {
    count = 1

    network {
      port "https" {
        static = 443
      }

     port "http" {
       static = 80
     }

      port "api" {
        static = 8081
      }

      port "postgres" {
        static = 5432
      }

      port "rabbimq" {
        static = 5672
      }
    }

    service {
      name = "traefik"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "https"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik"
        network_mode = "host"
        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        data = <<EOF
[entryPoints]
    [entryPoints.websecure]
    address = ":443"
    [entryPoints.traefik]
    address = ":8081"
    [entryPoints.web]
    Address = ":80"
    [entryPoints.rabbitmq]
    Address = ":5672"
    [entryPoints.postgres]
    Address = ":5432"


[api]
    dashboard = true
    insecure  = true

# Enable Consul Catalog configuration backend.
[providers.consulCatalog]
    prefix           = "traefik"
    exposedByDefault = false

    [providers.consulCatalog.endpoint]
      address = "YOUR_CONSUL_CATALOG_IP_WITH_PORT"
      scheme  = "http"

[certificatesResolvers.myresolver.acme]
  email = "YOUR_ACME_EMAIL"
  storage = "acme.json"
  [certificatesResolvers.myresolver.acme.httpChallenge]
    # used during the challenge
    entryPoint = "web"

EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}

