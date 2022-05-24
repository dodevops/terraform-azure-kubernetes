# Azure Kubernetes Services

## Introduction

This module manages a Azure Kubernetes Services cluser. Besides the cluster itself it manages a defined amount of outbound IPs

## Usage

Instantiate the module by calling it from Terraform like this:

```hcl
module "azure-k8s" {
  source  = "dodevops/kubernetes/azure"
  version = "<version>"
}
```

<!-- BEGIN_TF_DOCS -->
# General notes

When using more than one node pool, the load balancer sku "Basic" is not supported. It needs to be at least "Standard", see
https://docs.microsoft.com/azure/aks/use-multiple-node-pools

All "System" mode pools must be able to reach all pods/subnets

## Requirements

No requirements.

## Providers

The following providers are used by this module:

- azurerm

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_kubernetes_cluster.k8s](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) (resource)
- [azurerm_kubernetes_cluster_node_pool.additional](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) (resource)
- [azurerm_public_ip.public-ip-outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)

## Required Inputs

The following input variables are required:

### api\_server\_ip\_ranges

Description: The IP ranges to allow for incoming traffic to the server nodes. To disable the limitation, set an empty list as value.

Type: `list(string)`

### client\_id

Description: Azure client ID to use to manage Azure resources from the cluster, like f.e. load balancers

Type: `string`

### client\_secret

Description: Azure client secret to use to manage Azure resources from the cluster, like f.e. load balancers

Type: `string`

### default\_node\_pool\_k8s\_version

Description: Version of kubernetes for the default node pool

Type: `string`

### kubernetes\_version

Description: Version of kubernetes of the control plane

Type: `string`

### location

Description: Azure location to use

Type: `string`

### node\_count

Description: Number of Kubernetes cluster nodes to use

Type: `string`

### project

Description: Three letter project key

Type: `string`

### rbac\_managed\_admin\_groups

Description: The group IDs that have admin access to the cluster. Have to be specified if rbac\_enabled is true

Type: `list(string)`

### resource\_group

Description: Azure Resource Group to use

Type: `string`

### ssh\_public\_key

Description: SSH public key to access the kubernetes node with

Type: `string`

### stage

Description: Stage for this ip

Type: `string`

### subnet\_id

Description: ID of subnet to host the nodes, pods and services in.

Type: `string`

### vm\_size

Description: Type of vm to use. Use az vm list-sizes --location <location> to list all available sizes

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### availability\_zones

Description: availability zones to spread the cluster nodes across, if omitted, only one avilability zone is used

Type: `list(number)`

Default: `[]`

### default\_node\_pool\_name

Description: Name of the default node pool

Type: `string`

Default: `"default"`

### dns\_prefix

Description: DNS-Prefix to use. Defaults to cluster name

Type: `string`

Default: `"NONE"`

### idle\_timeout

Description: Desired outbound flow idle timeout in minutes for the cluster load balancer. Must be between 4 and 120 inclusive.

Type: `number`

Default: `5`

### load\_balancer\_sku

Description: The SKU for the used Load Balancer

Type: `string`

Default: `"Basic"`

### max\_pods

Description: Amount of pods allowed on each node (be aware that kubernetes system pods are also counted

Type: `string`

Default: `"30"`

### network\_policy

Description: Network policy to use, currently only azure and callico are supported

Type: `string`

Default: `"azure"`

### node\_pools

Description: Additional node pools to set up

Type:

```hcl
map(object({
    vm_size : string,
    count : number,
    os_disk_size_gb : number,
    k8s_version : string,
    node_labels : map(string),
    max_pods : number,
    mode : string,
    taints : list(string),
    availability_zones : list(number)
  }))
```

Default: `{}`

### node\_storage

Description: Disk size in GB

Type: `string`

Default: `"30"`

### outbound\_ports\_allocated

Description: Pre-allocated ports (AKS default: 0)

Type: `number`

Default: `0`

### rbac\_enabled

Description: Enables RBAC on the cluster. If true, rbac\_managed\_admin\_groups have to be specified.

Type: `bool`

Default: `true`

### sku\_tier

Description: n/a

Type: `string`

Default: `"Free"`

### static\_outbound\_ip\_count

Description:     On a lot of outgoing connections use this together with the maximum for outbound\_ports\_allocated of 64000 to not fall into network  
    bottlenecks. Recommended in that case is to set the count at least +5 more than the count of kubernetes nodes.

Type: `number`

Default: `0`

### tags

Description: Map of tags for the resources

Type: `map(any)`

Default: `{}`

## Outputs

The following outputs are exported:

### client\_certificate

Description: n/a

### client\_certificate\_admin

Description: n/a

### client\_key

Description: n/a

### client\_key\_admin

Description: n/a

### client\_token

Description: n/a

### client\_token\_admin

Description: n/a

### cluster\_ca\_certificate

Description: n/a

### cluster\_id

Description: n/a

### cluster\_name

Description: n/a

### fqdn

Description: n/a

### host

Description: n/a

### node\_resource\_group

Description: n/a

### public\_outbound\_ips

Description: n/a
<!-- END_TF_DOCS -->