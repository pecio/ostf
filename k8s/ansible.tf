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

  variables = {
    harbor_ip           = openstack_compute_instance_v2.harbor.access_ip_v4
    credential_id       = openstack_identity_application_credential_v3.kubernetes.id
    credential_secret   = openstack_identity_application_credential_v3.kubernetes.secret
    floating_network_id = data.openstack_networking_network_v2.public.id
    subnet_id           = data.openstack_networking_subnet_v2.private_subnet.id
    openstack_auth_url  = local.identity_url
    share_network_id    = openstack_sharedfilesystem_sharenetwork_v2.sharenetwork.id
  }
}

resource "ansible_group" "all" {
  name = "all"

  variables = {
    ansible_ssh_private_key_file = local_sensitive_file.private_key.filename
    ansible_user                 = "ubuntu"

    suffix = random_pet.suffix.id
  }
}

resource "ansible_host" "harbor" {
  name = "harbor"

  variables = {
    ansible_host = openstack_compute_floatingip_v2.harbor.address
  }
}
