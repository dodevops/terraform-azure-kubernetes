/**
 * # General notes
 *
 * When using more than one node pool, the load balancer sku "Basic" is not supported. It needs to be at least "Standard", see
 * https://docs.microsoft.com/azure/aks/use-multiple-node-pools
 *
 * All "System" mode pools must be able to reach all pods/subnets
 */

locals {
  cluster_name = "${lower(var.project)}${lower(var.stage)}k8s"
}

# Log analytics required for OMS Agent result processing - usually other logging solutions are used. Hence the affected tfsec rule is
# ignored here
#
# IP limit for API is not really ignored, since the variable requires to enter something. However one can decide to disable the limitation
# and it would trigger the tfsec rule. Hence the affected tfsec rule is ignored here
#
#tfsec:ignore:azure-container-logging tfsec:ignore:azure-container-limit-authorized-ips
resource "azurerm_kubernetes_cluster" "k8s" {
  name                            = local.cluster_name
  location                        = var.location
  resource_group_name             = var.resource_group
  tags                            = var.tags
  dns_prefix                      = var.dns_prefix == "NONE" ? local.cluster_name : var.dns_prefix
  sku_tier                        = var.sku_tier
  kubernetes_version              = var.kubernetes_version
  api_server_authorized_ip_ranges = var.api_server_ip_ranges

  default_node_pool {
    name                 = var.default_node_pool_name
    type                 = "VirtualMachineScaleSets"
    node_count           = var.node_count
    vm_size              = var.vm_size
    os_disk_size_gb      = var.node_storage
    vnet_subnet_id       = var.subnet_id
    max_pods             = var.max_pods
    orchestrator_version = var.default_node_pool_k8s_version
    zones                = var.availability_zones
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control_enabled = var.rbac_enabled
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.rbac_managed_admin_groups
    azure_rbac_enabled     = var.rbac_enabled
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = var.network_policy
    load_balancer_sku = length(var.node_pools) > 0 ? "Standard" : var.load_balancer_sku
    dynamic "load_balancer_profile" {
      for_each = azurerm_public_ip.public-ip-outbound
      content {
        outbound_ip_address_ids  = azurerm_public_ip.public-ip-outbound[*].id
        outbound_ports_allocated = var.outbound_ports_allocated
        idle_timeout_in_minutes  = var.idle_timeout
      }
    }
  }

  linux_profile {
    admin_username = var.project
    ssh_key {
      key_data = var.ssh_public_key
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  name                  = each.key
  node_count            = each.value.count
  vm_size               = each.value.vm_size
  os_disk_size_gb       = each.value.os_disk_size_gb
  vnet_subnet_id        = var.subnet_id
  node_labels           = each.value.node_labels
  max_pods              = each.value.max_pods
  orchestrator_version  = each.value.k8s_version
  mode                  = each.value.mode
  node_taints           = each.value.taints
  zones                 = each.value.availability_zones
}

resource "azurerm_public_ip" "public-ip-outbound" {
  count = var.static_outbound_ip_count

  name                = "${local.cluster_name}ippublicoutbound${count.index}"
  allocation_method   = "Static"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"
}
