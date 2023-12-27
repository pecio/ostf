resource "openstack_compute_keypair_v2" "keypair" {
  name = "keypair-${random_pet.suffix.id}"
}

resource "local_sensitive_file" "private_key" {
  filename        = "${path.module}/id-${random_pet.suffix.id}"
  content         = openstack_compute_keypair_v2.keypair.private_key
  file_permission = "0600"
}
