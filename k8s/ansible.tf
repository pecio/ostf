resource "ansible_host" "node" {
  count = var.nodes

  name = "node${count.index}"

  groups = [ansible_group.k8s.name]

  variables = {
    ansible_host = openstack_compute_floatingip_v2.node[count.index].address
  }
}

resource "ansible_group" "k8s" {
  name = "k8s"
}

resource "ansible_group" "all" {
  name = "all"

  variables = {
    ansible_ssh_private_key_file = local_sensitive_file.private_key.filename
    ansible_user                 = "ubuntu"
  }
}

resource "ansible_host" "harbor" {
  name = "harbor"

  variables = {
    ansible_host = openstack_compute_floatingip_v2.harbor.address
  }
}
