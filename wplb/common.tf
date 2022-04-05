terraform {
  required_version = ">= 1.0.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

resource "random_pet" "suffix" {
  separator = "-"
}

resource "random_password" "database_password" {
  length = 16
}

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

resource "openstack_networking_secgroup_v2" "mysql" {
  name        = "mysql-${random_pet.suffix.id}"
  description = "Allow MySQL access"
}

resource "openstack_networking_secgroup_rule_v2" "mysql" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  security_group_id = openstack_networking_secgroup_v2.mysql.id
}

resource "openstack_networking_secgroup_v2" "webserver" {
  name        = "webserver-${random_pet.suffix.id}"
  description = "Allow web access"
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  security_group_id = openstack_networking_secgroup_v2.webserver.id
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  security_group_id = openstack_networking_secgroup_v2.webserver.id
}
