locals {
  frontend_cidr = "192.168.100.0/24"
  backend_cidr  = "192.168.200.0/24"
}

resource "openstack_networking_network_v2" "frontend" {
  name = "frontend-${random_pet.suffix.id}"
}

resource "openstack_networking_subnet_v2" "frontend" {
  name       = "frontend-${random_pet.suffix.id}"
  network_id = openstack_networking_network_v2.frontend.id
  cidr       = local.frontend_cidr
}

resource "openstack_networking_network_v2" "backend" {
  name = "backend-${random_pet.suffix.id}"
}

resource "openstack_networking_subnet_v2" "backend" {
  name       = "backend-${random_pet.suffix.id}"
  network_id = openstack_networking_network_v2.backend.id
  cidr       = local.backend_cidr
}

data "openstack_networking_network_v2" "public" {
  name = "public"
}

resource "openstack_networking_router_v2" "external" {
  name                = "external-${random_pet.suffix.id}"
  external_network_id = data.openstack_networking_network_v2.public.id
}

resource "openstack_networking_router_interface_v2" "external-frontend" {
  router_id = openstack_networking_router_v2.external.id
  subnet_id = openstack_networking_subnet_v2.frontend.id
}

resource "openstack_networking_router_v2" "internal" {
  name = "internal-${random_pet.suffix.id}"
}

resource "openstack_networking_router_interface_v2" "internal-backend" {
  router_id = openstack_networking_router_v2.internal.id
  subnet_id = openstack_networking_subnet_v2.backend.id
}

resource "openstack_networking_port_v2" "internal-frontend" {
  network_id = openstack_networking_network_v2.frontend.id
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.frontend.id
  }
}

resource "openstack_networking_router_interface_v2" "internal-frontend" {
  router_id = openstack_networking_router_v2.internal.id
  port_id   = openstack_networking_port_v2.internal-frontend.id
}

resource "openstack_networking_subnet_route_v2" "frontend-backend" {
  subnet_id        = openstack_networking_subnet_v2.frontend.id
  destination_cidr = local.backend_cidr
  next_hop         = openstack_networking_port_v2.internal-frontend.all_fixed_ips[0]
}