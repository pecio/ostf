resource "openstack_networking_secgroup_v2" "ssh" {
  name        = "ssh-${random_pet.suffix.id}"
  description = "Allow SSH access for testing"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  security_group_id = openstack_networking_secgroup_v2.ssh.id
}

resource "openstack_networking_secgroup_v2" "k8s" {
  name        = "k8s-${random_pet.suffix.id}"
  description = "Allow access to K8s"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_internal" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.k8s.id
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

resource "openstack_networking_secgroup_rule_v2" "k8s_nodeports" {
  for_each = toset(["tcp", "udp"])

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = each.value
  port_range_min    = 30000
  port_range_max    = 31999
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

resource "openstack_networking_secgroup_rule_v2" "k8s_api_server" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

resource "openstack_networking_secgroup_v2" "harbor" {
  name        = "harbor-${random_pet.suffix.id}"
  description = "Allow harbor ports"
}

resource "openstack_networking_secgroup_rule_v2" "harbor" {
  for_each = {
    http  = 80
    https = 443
    trust = 4443
  }

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = each.value
  port_range_max    = each.value
  security_group_id = openstack_networking_secgroup_v2.harbor.id
}
