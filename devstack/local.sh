#! /bin/bash
# Postinstall
set -o xtrace
# Generate Amphora image
(
  . ~/devstack/openrc admin admin
  if [[ -z "$(openstack image list -f value -c Name | fgrep amphora-x64-haproxy)" ]]; then
    WORKDIR=$(/usr/bin/mktemp -d)
    cd "${WORKDIR}"
    /usr/bin/python3 -mvenv octavia-diskimage-venv
    . ./octavia-diskimage-venv/bin/activate
    pip install -r /opt/stack/octavia/diskimage-create/requirements.txt
    /opt/stack/octavia/diskimage-create/diskimage-create.sh
    openstack image create --disk-format qcow2 \
      --container-format bare --tag amphora --file amphora-x64-haproxy.qcow2 \
      --private --project service amphora-x64-haproxy
    cd
    /bin/rm -rf "${WORKDIR}"
  fi
)
# Create Octavia flavorprofile and flavor
(
  . ~/devstack/openrc admin admin
  # Note flavorprofile has "name" column instead of "Name"
  if [[ -z "$(openstack loadbalancer flavorprofile list -f value -c name | fgrep amphora-single-profile)" ]]; then
    openstack loadbalancer flavorprofile create --provider amphora \
      --name amphora-single-profile \
      --flavor-data '{"loadbalancer_topology": "SINGLE", "compute_flavor": "1"}'
  fi
  if [[ -z "$(openstack loadbalancer profile list -f value -c Name | fgrep standalone-lb)" ]]; then
    openstack loadbalancer flavor create --name standalone-lb \
      --flavorprofile amphora-single-profile \
      --description "A non-high availability load balancer for testing." \
      --enable
  fi
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
