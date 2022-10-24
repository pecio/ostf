resource "openstack_lb_loadbalancer_v2" "frontend" {
  name          = "frontend-${random_pet.suffix.id}"
  vip_subnet_id = openstack_networking_subnet_v2.frontend.id
}

resource "openstack_lb_listener_v2" "http" {
  name            = "http-${random_pet.suffix.id}"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.frontend.id
  default_pool_id = openstack_lb_pool_v2.webservers.id
}

resource "openstack_lb_pool_v2" "webservers" {
  protocol        = "HTTP"
  lb_method       = "ROUND_ROBIN"
  loadbalancer_id = openstack_lb_loadbalancer_v2.frontend.id
  name            = "webpool-${random_pet.suffix.id}"
}

resource "openstack_lb_member_v2" "webserver" {
  count         = var.webserver_instances
  pool_id       = openstack_lb_pool_v2.webservers.id
  name          = "webserver-${count.index}-${random_pet.suffix.id}"
  address       = openstack_compute_instance_v2.webserver[count.index].network[0].fixed_ip_v4
  protocol_port = 80
}

resource "openstack_networking_floatingip_v2" "frontend" {
  pool = "public"
}

resource "openstack_networking_floatingip_associate_v2" "frontend" {
  floating_ip = openstack_networking_floatingip_v2.frontend.address
  port_id     = openstack_lb_loadbalancer_v2.frontend.vip_port_id
}
