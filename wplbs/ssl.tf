resource "openstack_keymanager_secret_v1" "pfx" {
  name                     = "pfx-${random_pet.suffix.id}"
  payload_content_type     = "application/octet-stream"
  payload                  = filebase64("../certs/server.pfx")
  payload_content_encoding = "base64"
}

resource "openstack_lb_listener_v2" "ssl_listener" {
  name                      = "https-${random_pet.suffix.id}"
  protocol                  = "TERMINATED_HTTPS"
  protocol_port             = 443
  loadbalancer_id           = openstack_lb_loadbalancer_v2.frontend.id
  default_tls_container_ref = openstack_keymanager_secret_v1.pfx.secret_ref
  default_pool_id           = openstack_lb_pool_v2.webservers.id
}
