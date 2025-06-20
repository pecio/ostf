#! /bin/bash
# Postinstall
set -o xtrace
# Fix Glance permissions
# Otherwise, Manila fails to launch share servers
(
  . ~/devstack/openrc admin admin
  openstack role add --project service --user glance reader
)
# Create packer security group
(
  . ~/devstack/openrc demo demo
  if [[ -z "$(openstack security group list -f value -c Name | grep '^packer$')" ]]; then
    openstack security group create --description "Packer security group" packer
    openstack security group rule create --description "SSH access" \
      --dst-port 22 --protocol tcp --ingress packer
  fi
)
# Grant demo secret creator role
(
  . ~/devstack/openrc admin demo
  openstack role add --project demo --user demo creator
)
