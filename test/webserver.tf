terraform {
  required_version = ">= 1.0.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

resource "openstack_compute_instance_v2" "webserver" {
  name            = "webserver"
  image_name      = "wsimage"
  flavor_id       = "d2"
  key_pair        = "bichejo"
  security_groups = ["default", "ssh"]

  network {
    name = "private"
  }
}

resource "openstack_compute_floatingip_v2" "floatingip1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip1" {
  floating_ip = openstack_compute_floatingip_v2.floatingip1.address
  instance_id = openstack_compute_instance_v2.webserver.id
}

output "webserver_address" {
  value = openstack_compute_floatingip_v2.floatingip1.address
}
