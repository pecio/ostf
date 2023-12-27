terraform {
  required_version = ">= 1.6.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.1.0"
    }
  }
}
