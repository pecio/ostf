# K8s - OpenShift integration
resource "openstack_identity_application_credential_v3" "kubernetes" {
  name        = "kubernetes"
  description = "Kubernetes"
}

data "openstack_networking_network_v2" "public" {
  name = "public"
}

data "openstack_networking_subnet_v2" "private_subnet" {
  name = "private-subnet"
}
