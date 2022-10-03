# Traefik

## Synopsis
Unlike Kubernetes, Hashicorp Nomad does not come with the load balancer nor ingress. Nomad does not know any of these.
But there is a simple workaround for that: Traefik.

Traefik is a simple container that connects to your Hashicorp Consul Catalog and seeks for available services.
Traefik is aware of these services thanks to its autodiscovery feature that seeks for labels in Consul Catalog.
Thanks to that you are able to create dynamic configuration in your nomad files!!!

In this example we are creating a traefik as a service (which means that traefik will be deployed on all Nomad Agents).
You can furtherly narrow down Nomad workers using placement labels.

This recipe (`traefik.nomad`) will create a Traefik container that:
  - exposes publicly HTTP and HTTPS port
  - exposes publicly port 5432 and 5672 (used for PostgreSQL and RabbitMQ respectively)
  - exposes port 8081 for its API and dashboard.

Depending on your needs you can cut down or extend the ports as needed.


## Requirements

- This recipe requires that you have a working Consul Service.

## Remarks

I will create in some time Consul-less Traefik workload.

## Example

Lets assume user has got following scenario.

Single-node Nomad agent has got a public IP. Ops would like to have servie scheduling in service
mesh and uses Nomad to do so. Ops also uses Consul for automatic service discovery. Ops installs Traefik with
Consul Catalog support for autodiscovery and service routing. The Traefik dynamically routes traffic to the
correct containers. For HTTPS the Ops would have to have Let's Encrypt deployed. Assuming he has correct DNS
entries at his registrar he is able to do so.
