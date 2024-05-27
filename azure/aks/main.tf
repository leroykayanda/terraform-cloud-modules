module "aks" {
  source                                            = "Azure/aks/azurerm"
  version                                           = "8.0.0"
  resource_group_name                               = var.resource_group_name
  cluster_name                                      = var.cluster_name
  prefix                                            = var.prefix
  vnet_subnet_id                                    = var.vnet_subnet_id
  rbac_aad                                          = var.rbac_aad
  role_based_access_control_enabled                 = var.role_based_access_control_enabled
  rbac_aad_azure_rbac_enabled                       = var.rbac_aad_azure_rbac_enabled
  rbac_aad_managed                                  = var.rbac_aad_managed
  rbac_aad_admin_group_object_ids                   = [azuread_group.admins.object_id]
  local_account_disabled                            = false
  auto_scaler_profile_skip_nodes_with_local_storage = false
  auto_scaler_profile_skip_nodes_with_system_pods   = false
  agents_count                                      = var.default_node_pool["agents_count"]
  agents_availability_zones                         = var.default_node_pool["agents_availability_zones"]
  agents_min_count                                  = var.default_node_pool["agents_min_count"]
  agents_max_count                                  = var.default_node_pool["agents_max_count"]
  agents_pool_name                                  = var.default_node_pool["agents_pool_name"]
  agents_size                                       = var.default_node_pool["agents_size"]
  enable_auto_scaling                               = var.default_node_pool["enable_auto_scaling"]
  os_disk_size_gb                                   = var.default_node_pool["os_disk_size_gb"]
  agents_max_pods                                   = var.default_node_pool["agents_max_pods"]
  auto_scaler_profile_expander                      = var.auto_scaler_profile_expander
  agents_pool_max_surge                             = "10%"
  net_profile_service_cidr                          = var.net_profile_service_cidr
  net_profile_dns_service_ip                        = var.net_profile_dns_service_ip
  automatic_channel_upgrade                         = var.automatic_channel_upgrade
  log_analytics_workspace_enabled                   = var.log_analytics_workspace_enabled
  maintenance_window                                = var.maintenance_window
  maintenance_window_auto_upgrade                   = var.maintenance_window_auto_upgrade
  maintenance_window_node_os                        = var.maintenance_window_node_os
  sku_tier                                          = var.sku_tier
  network_plugin                                    = var.network_plugin
  net_profile_outbound_type                         = var.net_profile_outbound_type
  temporary_name_for_rotation                       = "tempnodepool"
  oidc_issuer_enabled                               = true
  workload_identity_enabled                         = true

  brown_field_application_gateway_for_ingress = {
    id        = azurerm_application_gateway.gateway.id
    subnet_id = var.application_gateway_subnet_id
  }
}
