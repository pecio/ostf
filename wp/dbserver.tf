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

  block_device {
    uuid                  = data.openstack_images_image_v2.dbimage.id
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.dbvol.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 1
    delete_on_termination = false
  }

  user_data = data.template_file.provision_db.rendered
}

data "template_file" "provision_db" {
  template = file("../scripts/provision-db-vol.sh.tmpl")
  vars = {
    db_name = var.database_name
    db_user = var.database_user
    db_pass = random_password.database_password.result
  }
}

resource "openstack_blockstorage_volume_v3" "dbvol" {
  name = "dbvol"
  size = 1
}
