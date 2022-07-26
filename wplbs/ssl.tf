resource "openstack_keymanager_secret_v1" "certificate" {
  name                 = "certificate-${random_pet.suffix.id}"
  payload_content_type = "text/plain"
  payload              = file("../certs/server.pem")
  secret_type          = "certificate"
}

resource "openstack_keymanager_secret_v1" "private_key" {
  name                 = "private_key-${random_pet.suffix.id}"
  payload_content_type = "text/plain"
  payload              = file("../certs/server.key")
  secret_type          = "private"
  algorithm            = "RSA"
}

resource "openstack_keymanager_secret_v1" "intermediate" {
  name                 = "intermediate-${random_pet.suffix.id}"
  payload_content_type = "text/plain"
  payload              = file("../certs/ca-int.pem")
  secret_type          = "certificate"
}

resource "openstack_keymanager_container_v1" "tls_container" {
  name = "tls_container-${random_pet.suffix.id}"
  type = "certificate"

  secret_refs {
    name       = "certificate"
    secret_ref = openstack_keymanager_secret_v1.certificate.secret_ref
  }

  secret_refs {
    name       = "private_key"
    secret_ref = openstack_keymanager_secret_v1.private_key.secret_ref
  }

  secret_refs {
    name       = "intermediates"
    secret_ref = openstack_keymanager_secret_v1.intermediate.secret_ref
  }
}

resource "openstack_lb_listener_v2" "ssl_listener" {
  name                      = "https-${random_pet.suffix.id}"
  protocol                  = "TERMINATED_HTTPS"
  protocol_port             = 443
  loadbalancer_id           = openstack_lb_loadbalancer_v2.frontend.id
  default_tls_container_ref = openstack_keymanager_container_v1.tls_container.container_ref
}
