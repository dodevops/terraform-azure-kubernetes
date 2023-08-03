resource "azurerm_role_assignment" "aksacr" {
  for_each                         = var.azure_container_registry_ids
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = each.value
  skip_service_principal_aad_check = true
}