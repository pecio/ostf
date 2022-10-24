# !/bin/sh
(
  . ~/devstack/openrc admin demo
  openstack role add --project demo --user demo creator
)
