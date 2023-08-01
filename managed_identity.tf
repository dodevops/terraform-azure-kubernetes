# Assign the k8s managed identity to a security group

data "azuread_group" "ownersgroup" {
  count        = var.add_identity_to_group == "" ? 0 : 1
  display_name = var.add_identity_to_group
}

resource "azuread_group_member" "k8smember" {
  count            = var.add_identity_to_group == "" ? 0 : 1
  group_object_id  = data.azuread_group.ownersgroup[0].object_id
  member_object_id = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}