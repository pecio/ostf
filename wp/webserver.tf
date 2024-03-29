data "openstack_images_image_v2" "wsimage" {
  name        = "wsimage"
  most_recent = true
}

resource "openstack_compute_instance_v2" "webserver" {
  name        = "webserver-${random_pet.suffix.id}"
  image_id    = data.openstack_images_image_v2.wsimage.id
  flavor_name = "ds1G"
  key_pair    = "bichejo"
  security_groups = [
    openstack_networking_secgroup_v2.webserver.name,
    openstack_networking_secgroup_v2.ssh.name
  ]

  network {
    name = openstack_networking_network_v2.frontend.name
  }

  depends_on = [openstack_networking_subnet_v2.frontend]

  user_data = data.template_file.provision_ws.rendered
}

data "template_file" "provision_ws" {
  template = file("../scripts/provision-ws.sh.tmpl")
  vars = {
    db_name = var.database_name
    db_user = var.database_user
    db_pass = random_password.database_password.result
    db_addr = openstack_compute_instance_v2.dbserver.network[0].fixed_ip_v4
    use_ssl = false
  }
}

resource "openstack_compute_floatingip_v2" "floatingip1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip1" {
  floating_ip = openstack_compute_floatingip_v2.floatingip1.address
  instance_id = openstack_compute_instance_v2.webserver.id
}
