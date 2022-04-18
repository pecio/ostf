#! /bin/bash
# Postinstall
set -o xtrace
# Generate Amphora image
(
  WORKDIR=$(/usr/bin/mktemp -d)
  cd "${WORKDIR}"
  /usr/bin/sudo /opt/stack/octavia/diskimage-create/diskimage-create.sh
  . ~/devstack/openrc admin admin
  openstack image create --disk-format qcow2 \
    --container-format bare --tag amphora --file amphora-x64-haproxy.qcow2 \
    --private --project service amphora-x64-haproxy
  cd
  /bin/rm -rf "${WORKDIR}"
)
# Create Octavia flavorprofile and flavor
(
  . ~/devstack/openrc admin admin
  openstack loadbalancer flavorprofile create --provider amphora \
    --name amphora-single-profile \
    --flavor-data '{"loadbalancer_topology": "SINGLE", "compute_flavor": "1"}'
  openstack loadbalancer flavor create --name standalone-lb \
    --flavorprofile amphora-single-profile \
    --description "A non-high availability load balancer for testing." \
    --enable
)
# Import public keys from authorized_keys
(
  . ~/devstack/openrc demo demo
  while read type key description; do
    if [[ -n "${description}" ]]; then
      openstack keypair create "${description}" --public-key <(echo "${type} ${key} ${description}")
    fi
  done < ~/.ssh/authorized_keys
)
# Create "ssh" security group
(
  . ~/devstack/openrc demo demo
  openstack security group create ssh
  openstack security group rule create ssh --dst-port 22 --protocol tcp
)
