# Octavia Amphora image creation

The `local.rc` file contains the line
```
DISABLE_AMP_IMAGE_BUILD=True
```
to disable the creation of the Amphora (haproxy) image. This means
Octavia will not be able to use the Amphora provider.

## Why?
Image creation through devstack fails and I have been unable to find
the root cause. Actual creation of the image file seems to work, but
creating (importing) it on Glance fails. During import, syslog shows a
lot of "Guru Meditation"s for several components and the image
dissapears from Glance.

## How to fix?
Easy. Image creation _after installation_ works flawlessly. One just
has to follow [the official instructions in OpenStack Octavia
documentation](https://docs.openstack.org/octavia/latest/admin/amphora-image-build.html).
Running `/opt/stack/octavia/diskimage-create/diskimage-create.sh`
without arguments after installing the prerequisites documented in that
page will generate an `amphora-x64-haproxy.qcow2` file in the current
directory and you just have to run
```
openstack image create amphora-x64-haproxy --public --disk-format qcow2 --file amphora-x64-haproxy.qcow2
```
in order to import it in Glance.
