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

data "openstack_networking_port_v2" "harbor" {
  device_id  = openstack_compute_instance_v2.harbor.id
  network_id = openstack_compute_instance_v2.harbor.network[0].uuid
}

resource "openstack_networking_floatingip_v2" "harbor" {
  pool = "public"
}

resource "openstack_networking_floatingip_associate_v2" "harbor" {
  floating_ip = openstack_networking_floatingip_v2.harbor.address
  port_id     = data.openstack_networking_port_v2.harbor.id
}
