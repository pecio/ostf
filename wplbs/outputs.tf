output "address" {
  value = openstack_networking_floatingip_v2.frontend.address
}

output "url" {
  value = "http://${openstack_networking_floatingip_v2.frontend.address}/blog/"
}

output "ssl_url" {
  value = "https://${openstack_networking_floatingip_v2.frontend.address}/blog/"
}
