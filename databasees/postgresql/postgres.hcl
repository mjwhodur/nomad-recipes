job "databases" {
  
  datacenters = ["ph"]

  // Jobs are split onto groups and groups onto tasks.
  group "postgres_db" {

    network {
      mode = "bridge"
      port "db" {
        to = 5432
      }
    }

    volume "postgresvol" {
    type = "host"
    source = "postgres"

}

  // Consul Service part. Enables traefik routing (among other functionalities).
    service {
      // name - stands for name that will be provided in Consul Catalog
      name = "postgresdb"
      // task - stands for the name of the task that the Consul shall refer to
      task = "postgressqlserver"
      port = "db"


      // Simple tags for Traefik. Consult ../loadbalancers_ingress/traefik.nomad for integration.
      // With those tags Traefik will automatically discover the Postgres and enable routing into the container.
      tags = [
        "traefik.enable=true",
        "traefik.tcp.routers.router_to_postgres.entrypoints=postgres",
        "traefik.tcp.routers.router_to_postgres.service=postgresdb",
        "traefik.tcp.routers.router_to_postgres.rule=HostSNI(`*`)"
      ]

      // Enable Native Consul Connect
      connect {
        native = true
      }

    }
  
  // The task is the container itself.
    task "postgressqlserver" {

      driver = "docker"
      
      volume_mount {
        volume      = "postgresvol"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      config {
        image = "postgres:13"
      }

      env {
        POSTGRES_PASSWORD = "supersecretpassword"
      }

      // Resource amount is actually up to you. I provided example values.
      resources {
        cpu    = 1000
        memory = 2048
      }
    }

  }
 
}
