resource "openstack_keymanager_secret_v1" "pfx" {
  name                     = "pfx-${random_pet.suffix.id}"
  payload_content_type     = "application/octet-stream"
  payload                  = filebase64("../certs/server.pfx")
  payload_content_encoding = "base64"
  secret_type              = "certificate"
}

resource "openstack_keymanager_secret_v1" "server" {
  name                 = "server-${random_pet.suffix.id}"
  payload_content_type = "text/plain"
  payload              = file("../certs/server.pem")
  secret_type          = "certificate"
}

resource "openstack_keymanager_secret_v1" "serverkey" {
  name                 = "serverkey-${random_pet.suffix.id}"
  payload_content_type = "text/plain"
  payload              = file("../certs/server.key")
  secret_type          = "private"
}

resource "openstack_keymanager_secret_v1" "rootca" {
  name                 = "rootca-${random_pet.suffix.id}"
  payload_content_type = "text/plain"
  payload              = file("../certs/ca.pem")
  secret_type          = "certificate"
}

resource "openstack_keymanager_container_v1" "server" {
  name = "server-${random_pet.suffix.id}"
  type = "certificate"

  secret_refs {
    name       = "certificate"
    secret_ref = openstack_keymanager_secret_v1.server.secret_ref
  }

  secret_refs {
    name       = "private_key"
    secret_ref = openstack_keymanager_secret_v1.serverkey.secret_ref
  }

  secret_refs {
    name       = "intermediates"
    secret_ref = openstack_keymanager_secret_v1.rootca.secret_ref
  }
}

resource "openstack_lb_listener_v2" "ssl_listener" {
  name                      = "https-${random_pet.suffix.id}"
  protocol                  = "TERMINATED_HTTPS"
  protocol_port             = 443
  loadbalancer_id           = openstack_lb_loadbalancer_v2.frontend.id
  default_tls_container_ref = openstack_keymanager_container_v1.server.container_ref
  default_pool_id           = openstack_lb_pool_v2.webservers.id
}
