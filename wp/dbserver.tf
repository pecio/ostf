data "openstack_images_image_v2" "dbimage" {
  name        = "dbimage"
  most_recent = true
}

resource "openstack_compute_instance_v2" "dbserver" {
  name        = "dbserver-${random_pet.suffix.id}"
  image_id    = data.openstack_images_image_v2.dbimage.id
  flavor_name = "ds1G"
  key_pair    = "bichejo"
  security_groups = [
    openstack_networking_secgroup_v2.mysql.name,
    openstack_networking_secgroup_v2.ssh.name
  ]

  network {
    name = openstack_networking_network_v2.backend.name
  }

  depends_on = [openstack_networking_subnet_v2.backend]

  user_data = file("../scripts/provision-db-vol.sh")
  metadata = {
    db_name = var.database_name
    db_user = var.database_user
    db_pass = random_password.database_password.result
  }
}

resource "openstack_blockstorage_volume_v3" "dbvol" {
  name = "dbvol"
  size = 1
}

resource "openstack_compute_volume_attach_v2" "dbattachment" {
  instance_id = openstack_compute_instance_v2.dbserver.id
  volume_id   = openstack_blockstorage_volume_v3.dbvol.id
}
