packer {
  required_plugins {
    openstack = {
      version = "~>1"
      source  = "github.com/hashicorp/openstack"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}
