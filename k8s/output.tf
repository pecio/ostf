output "node_address" {
  value = openstack_compute_floatingip_v2.node[*].address
}

output "suffix" {
  value = random_pet.suffix.id
}
