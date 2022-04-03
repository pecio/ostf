source "openstack" "wsimage" {
  image_name   = "wsimage"
  flavor       = "ds1G"
  ssh_username = "ubuntu"
  source_image_filter {
    most_recent = true
    filters {
      properties = {
        os_distro = "ubuntu"
      }
    }
  }
  security_groups           = ["default", "ssh"]
  networks                  = ["7ce30c31-9197-4ec4-83c8-3d9c28af5cd9"]
  floating_ip_network       = "public"
  ssh_clear_authorized_keys = true
}

build {
  sources = ["source.openstack.wsimage"]
}
