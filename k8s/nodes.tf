resource "openstack_compute_instance_v2" "node" {
  count = var.nodes

  name        = "node${count.index}-${random_pet.suffix.id}"
  image_name  = "k8snode"
  flavor_name = "m1.medium"
  key_pair    = openstack_compute_keypair_v2.keypair.name
  security_groups = [
    openstack_networking_secgroup_v2.ssh.name,
    openstack_networking_secgroup_v2.k8s.name
  ]

  network {
    name = "private"
  }
}

resource "openstack_compute_floatingip_v2" "node" {
  count = var.nodes

  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "node" {
  count = var.nodes

  floating_ip = openstack_compute_floatingip_v2.node[count.index].address
  instance_id = openstack_compute_instance_v2.node[count.index].id
}
