#! /bin/bash
# Postinstall
set -o xtrace
# Generate Amphora image
(
  . ~/devstack/openrc admin admin
  if [[ -z "$(openstack image list -f value -c Name | fgrep amphora-x64-haproxy)" ]]; then
    WORKDIR=$(/usr/bin/mktemp -d)
    cd "${WORKDIR}"
    /usr/bin/sudo /opt/stack/octavia/diskimage-create/diskimage-create.sh
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
