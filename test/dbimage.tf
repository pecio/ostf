resource "openstack_compute_instance_v2" "dbimage" {
  name            = "dbimage-${random_pet.suffix.id}"
  image_name      = "dbimage"
  flavor_id       = "d2"
  key_pair        = var.ssh_key_name
  security_groups = [openstack_networking_secgroup_v2.ssh.name]

  network {
    name = "private"
  }
}

resource "openstack_compute_floatingip_v2" "dbimage" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "dbimage" {
  floating_ip = openstack_compute_floatingip_v2.dbimage.address
  instance_id = openstack_compute_instance_v2.dbimage.id
}

output "dbimage_address" {
  value = openstack_compute_floatingip_v2.dbimage.address
}
