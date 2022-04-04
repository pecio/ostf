terraform {
  required_version = ">= 1.0.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

resource "openstack_compute_instance_v2" "wsimage" {
  name            = "wsimage-${random_pet.suffix.id}"
  image_name      = "wsimage"
  flavor_id       = "d2"
  key_pair        = var.ssh_key_name
  security_groups = [openstack_networking_secgroup_v2.ssh.name]

  network {
    name = "private"
  }
}

resource "openstack_compute_floatingip_v2" "wsimage" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "wsimage" {
  floating_ip = openstack_compute_floatingip_v2.wsimage.address
  instance_id = openstack_compute_instance_v2.wsimage.id
}

output "wsimage_address" {
  value = openstack_compute_floatingip_v2.wsimage.address
}
