resource "openstack_sharedfilesystem_sharenetwork_v2" "sharenetwork" {
  name              = "K8s_share_network_${random_pet.suffix.id}"
  description       = "Kubernetes share network"
  neutron_net_id    = data.openstack_networking_network_v2.private.id
  neutron_subnet_id = data.openstack_networking_subnet_v2.private_subnet.id
}

data "openstack_networking_network_v2" "private" {
  name = "private"
}
