# K8s - OpenShift integration
resource "openstack_identity_application_credential_v3" "kubernetes" {
  name        = "kubernetes-${random_pet.suffix.id}"
  description = "Kubernetes"
}

data "openstack_networking_network_v2" "public" {
  name = "public"
}

data "openstack_networking_subnet_v2" "private_subnet" {
  name = "private-subnet"
}

data "openstack_identity_auth_scope_v3" "scope" {
  name = "my_scope"
}
