source "openstack" "k8snode" {
  image_name                   = "k8snode"
  flavor                       = "ds512M"
  ssh_username                 = "ubuntu"
  external_source_image_url    = "https://cloud-images.ubuntu.com/minimal/daily/noble/current/noble-minimal-cloudimg-amd64.img"
  external_source_image_format = "qcow2"
  security_groups              = ["packer"]
  floating_ip_network          = "public"
  ssh_clear_authorized_keys    = true
  network_discovery_cidrs      = ["10.0.0.0/26"]
}

build {
  name    = "k8snode"
  sources = ["source.openstack.k8snode"]
  provisioner "ansible" {
    playbook_file   = "playbooks/k8snode.yml"
    user            = "ubuntu"
    extra_arguments = ["--scp-extra-args", "'-O'"]
  }
}
