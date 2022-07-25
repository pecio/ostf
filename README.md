# OpenStack and Terraform tests
This is inspired by the "Getting Started with OpenStack" course on
PluralSight. The course implemented a WordPress website using
OpenStack as IaaS.

This project is meant to do the same using IaC and add a LoadBalancer
in front.

## Directory Structure
* `devstack`: Provides `local.conf` and `local.sh` files to be put in
  the [DevStack](https://docs.openstack.org/devstack/latest/) directory
  in order to set up a test OpenStack environment.
* `packer`: Packer recipes for two Ubuntu 20.04 based images: an
  Apache/PHP webserver and a MariaDB server.
* `scripts`: Provisioning scripts (user_data) for the VMs in `wp*`
  directories.
* `test`: Terraform code to create and start a VM of each of the two
  images, assigning them a floating IP each and opening SSH, for sanity
  checks of the images.
* `wp`: Terraform code to create networks, Security Groups, routers, a
  Webserver VM and a MariaDB VM, installing WordPress and opening the
  web ports to outside.
* `wplb`: Builds on `wp`, adding an Octavia Load Balancer.
* `wplbs`: Builds on `wplb`, adding an HTTPS terminated listener to the
  Load Balancer.
* `certs`: A directory to hold the SSL certificates used by `wplbs`.
  Contains a `Makefile` to generate the needed ones but they can also
  be supplied, see the `README.md` file there.

## Requirements
* An Ubuntu 20.04 VM with:
  * At least 8 GB RAM (the more the better). My tests are done with a
    16 GB VM.
  * At least 200 GB hard disk, although tuning `local.conf` may get it
    to work with circa 30 GB of disk. My tests are done with a 250 GB
    disk VM.
  * Ability to do snapshots and revert to them is a must. Have at least
    a snapshot with the system just installed with the
    operating system configured but without having run `stack.sh` from
    DevStack.
  * VM is to be set up with a `stack` user with passwordless sudo. This
    is a normal requirement of DevStack.
  * systemd-resolver per-interface configuration bypased
    (`ln -sf /run/systemd/resolve/resolv.conf /etc`). Otherwise DNS
    starts failing halfway through DevStack execution catastrophically.
* Internet connectivity
* Time and patience

### DevStack patch for disabling arping
An `arping.patch` file is provided in `devstack` directory. It is meant
to be applied (`git apply ~/ostf/devstack/arping.patch`) in the
DevStack `~/devstack` directory.

Currently Ubuntu's `arping` command fails always when using `-A`
option. This results on DevStack thinking the network is not working
and aborting OpenStack setup.

## DevStack configuration
The `local.conf` file has been generated after *a lot* of trial and
error. Currently it sets up the environment as follows:
* Externally accesible public network using a "provider network". IP
  configuration matches my home set up with 192.168.1.0/24 network and
  192.168.1.200-254 available IP addresses and `enp3s0` physical
  interface.
* Totally insecure password ("secret") for all services.
* OVN based networking
* The following services enabled:
  * Neutron
  * Nova
  * Cinder
  * Swift
  * Glance backed by Swift
  * Horizon
  * Octavia
  * Barbican
  * Manila (not currently used by the Terraform code)
* Latest Ubuntu 22.04 Minimal image
* Latest *as of July 2022* Fedora 36 image (36-1.5)
