source "openstack" "dbimage" {
  image_name                   = "dbimage"
  flavor                       = "ds512M"
  ssh_username                 = "ubuntu"
  external_source_image_url    = "https://cloud-images.ubuntu.com/minimal/daily/jammy/current/jammy-minimal-cloudimg-amd64.img"
  external_source_image_format = "qcow2"
  security_groups              = ["packer"]
  floating_ip_network          = "public"
  ssh_clear_authorized_keys    = true
  network_discovery_cidrs      = ["10.0.0.0/26"]
}

build {
  name    = "dbimage"
  sources = ["source.openstack.dbimage"]
  provisioner "ansible" {
    playbook_file = "playbooks/dbimage.yml"
  }
}
