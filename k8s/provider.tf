terraform {
  required_version = ">= 1.6.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3"
    }
  }
}
