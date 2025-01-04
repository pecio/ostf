output "node_address" {
  value = openstack_networking_floatingip_v2.node[*].address
}

output "suffix" {
  value = random_pet.suffix.id
}

output "harbor_address" {
  value = openstack_networking_floatingip_v2.harbor.address
}
