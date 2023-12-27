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
  description = "Allow any for K8s"
}

resource "openstack_networking_secgroup_rule_v2" "k8s" {
  direction = "ingress"
  ethertype = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.k8s.id
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

resource "openstack_networking_secgroup_rule_v2" "k8s_ipv6" {
  direction = "ingress"
  ethertype = "IPv6"
  remote_group_id   = openstack_networking_secgroup_v2.k8s.id
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}
