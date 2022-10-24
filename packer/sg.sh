#!/bin/bash
# Create packer security group
. ~/devstack/openrc demo demo
if [[ -z "$(openstack security group list -f value -c Name | grep '^packer$')" ]]; then
  openstack security group create --description "Packer security group" packer
  openstack security group rule create --description "SSH access" \
    --dst-port 22 --protocol tcp --ingress packer
fi
