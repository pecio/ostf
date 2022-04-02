terraform {
  required_version = ">= 1.0.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

resource "openstack_compute_instance_v2" "test" {
  name            = "test"
  image_id        = "a54073fa-dc7e-4c64-94c4-654f0856b8bd"
  flavor_id       = "d2"
  key_pair        = "bichejo"
  security_groups = ["default"]

  network {
    name = "frontend"
  }
}

resource "openstack_compute_floatingip_v2" "floatingip1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip1" {
  floating_ip = openstack_compute_floatingip_v2.floatingip1.address
  instance_id = openstack_compute_instance_v2.test.id
}

output "address" {
  value = openstack_compute_floatingip_v2.floatingip1.address
}
