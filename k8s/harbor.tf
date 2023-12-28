resource "openstack_compute_instance_v2" "harbor" {
  name        = "harbor-${random_pet.suffix.id}"
  image_name  = "docker"
  flavor_name = "m1.small"
  key_pair    = openstack_compute_keypair_v2.keypair.name
  security_groups = [
    openstack_networking_secgroup_v2.ssh.name,
    openstack_networking_secgroup_v2.harbor.name
  ]

  network {
    name = "private"
  }
}

resource "openstack_compute_floatingip_v2" "harbor" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "harbor" {
  floating_ip = openstack_compute_floatingip_v2.harbor.address
  instance_id = openstack_compute_instance_v2.harbor.id
}
