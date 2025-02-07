output "host" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config[0].host
  description = "The Kubernetes API host for a kubectl config"
}

output "client_certificate" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate
  description = "The Kubernetes client certificate for a kubectl config"
}

output "client_key" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config[0].client_key
  description = "The Kubernetes client private key for a kubectl config"
}

output "cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  description = "The Kubernetes cluster ca certificate for a kubectl config"
}

output "fqdn" {
  value       = azurerm_kubernetes_cluster.k8s.fqdn
  description = "The FQDN to the Kubernetes API server"
}

output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.k8s.node_resource_group
  description = "The resource group the Kubernetes nodes were created in"
}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.k8s.name
  description = "The AKS cluster name"
}

output "cluster_id" {
  value       = azurerm_kubernetes_cluster.k8s.id
  description = "The AKS cluster id"
}

output "client_certificate_admin" {
  value       = length(azurerm_kubernetes_cluster.k8s.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.k8s.kube_admin_config[0].client_certificate : azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate
  description = "The Kubernetes client certificate for an admin access"
}

output "client_key_admin" {
  value       = length(azurerm_kubernetes_cluster.k8s.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.k8s.kube_admin_config[0].client_key : azurerm_kubernetes_cluster.k8s.kube_config[0].client_key
  description = "The Kubernetes client private key for an admin access"
}

output "client_token" {
  value       = azurerm_kubernetes_cluster.k8s.kube_config[0].password
  description = "A client token for accessing the Cluster using kubectl"
}

output "client_token_admin" {
  value       = length(azurerm_kubernetes_cluster.k8s.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.k8s.kube_admin_config[0].password : ""
  description = "A client token for accessing the Cluster using kubectl with an admin access"
}

output "public_outbound_ips" {
  value       = [azurerm_public_ip.public-ip-outbound[*].ip_address]
  description = "The outbound public IPs"
}

output "managed_identity_object_id" {
  value       = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
  description = "The object ID of the service principal of the managed identity of the AKS"
}

output "node_count" {
  value = var.node_count
}
