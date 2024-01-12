locals {
  identity_service = [for entry in data.openstack_identity_auth_scope_v3.scope.service_catalog :
  entry if entry.type == "identity"][0]
  identity_endpoint = [for endpoint in local.identity_service.endpoints :
  endpoint if(endpoint.interface == "public")][0]
  identity_url = local.identity_endpoint.url
}
