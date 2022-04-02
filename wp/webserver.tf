data "openstack_images_image_v2" "wsimage" {
  name        = "wsimage"
  most_recent = true
}

resource "openstack_compute_instance_v2" "webserver" {
  name            = "webserver"
  image_id        = data.openstack_images_image_v2.wsimage.id
  flavor_name     = "ds1G"
  key_pair        = "bichejo"
  security_groups = ["default", "webserver"]

  network {
    name = "frontend"
  }

  user_data = file("../scripts/provision-ws.sh")
  metadata = {
    db_name = var.database_name
    db_user = var.database_user
    db_pass = random_password.database_password.result
    db_addr = openstack_compute_instance_v2.dbserver.network[0].fixed_ip_v4
  }
}

resource "openstack_compute_floatingip_v2" "floatingip1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip1" {
  floating_ip = openstack_compute_floatingip_v2.floatingip1.address
  instance_id = openstack_compute_instance_v2.webserver.id
}
