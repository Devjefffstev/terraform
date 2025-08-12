# ☁️ Azure Terraform Examples

This directory contains practical examples for deploying Azure resources using Terraform. These examples demonstrate various Azure services and best practices for Infrastructure as Code.

## 🔐 Prerequisites

Before running any examples, you must authenticate with Azure using one of the following methods:

### Method 1: Azure CLI Authentication (Recommended for Development)
```bash
# Install Azure CLI if not already installed
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

# Login to Azure
az login

# Verify your subscription
az account show

# Set specific subscription if needed
az account set --subscription "Your Subscription Name"
```

### Method 2: Service Principal Authentication (Recommended for Production)
```bash
# Create a service principal
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"

# Export the credentials as environment variables
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### Method 3: Managed Identity (For Azure VMs)
```bash
# No additional setup required if running on Azure VM with managed identity
# Terraform will automatically use the managed identity
```

## 🏗️ Available Examples

### Basic Examples
- **Resource Group** - Creating and managing resource groups
- **Virtual Network** - Basic VNet with subnets
- **Storage Account** - Blob storage with different tiers
- **Virtual Machine** - Linux and Windows VMs

### Intermediate Examples
- **Load Balancer** - Application and network load balancers
- **App Service** - Web apps with deployment slots
- **Azure Database** - SQL Database and PostgreSQL
- **Key Vault** - Secrets and certificate management

### Advanced Examples
- **AKS Cluster** - Kubernetes cluster with node pools
- **Application Gateway** - Web application firewall
- **Azure Functions** - Serverless computing
- **Multi-Region Setup** - Cross-region deployments

## 🚀 Getting Started

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd terraform/examples/azure
```

### 2. Choose an Example
```bash
# Navigate to desired example
cd basic/resource-group
```

### 3. Review Variables
```bash
# Check the variables file
cat variables.tf

# Copy and customize the example tfvars
cp terraform.tfvars.example terraform.tfvars
```

### 4. Deploy
```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the changes
terraform apply
```

### 5. Cleanup
```bash
# Destroy resources when done
terraform destroy
```

## 📁 Directory Structure

```
azure/
├── basic/
│   ├── resource-group/
│   ├── virtual-network/
│   ├── storage-account/
│   └── virtual-machine/
├── intermediate/
│   ├── load-balancer/
│   ├── app-service/
│   ├── azure-database/
│   └── key-vault/
├── advanced/
│   ├── aks-cluster/
│   ├── application-gateway/
│   ├── azure-functions/
│   └── multi-region/
├── combined
└── README.examples.azure.md
```

## 🔧 Configuration Tips

### Terraform Backend Configuration
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstatesa"
    container_name       = "tfstate"
    key                  = "example.terraform.tfstate"
  }
}
```

## 🏷️ Naming Conventions

We follow Azure naming conventions:
- **Resource Groups**: `rg-{workload}-{environment}-{region}`
- **Storage Accounts**: `sa{workload}{environment}{region}`
- **Virtual Networks**: `vnet-{workload}-{environment}-{region}`
- **Virtual Machines**: `vm-{workload}-{environment}-{instance}`

Note: Refer to oficial documentation or you can use the module `namingConvention`

## 🔍 Troubleshooting

### Common Issues

**Authentication Errors**
```bash
# Check Azure CLI login status
az account show

# Re-authenticate if needed
az login --use-device-code
```

**Resource Name Conflicts**
```bash
# Check if resource name is already taken
az storage account check-name --name mystorageaccount
```

**Quota Limits**
```bash
# Check quotas and usage
az vm list-usage --location "East US" --output table
```

## 📚 Additional Resources

- [Azure Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure Resource Manager Templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/)

## 🤝 Contributing

When adding new examples:
1. Follow the existing directory structure
2. Include comprehensive documentation
3. Add terraform-docs generation
4. Include terraform.tfvars.example
5. Test in multiple Azure regions

---

💡 **Tip**: Start with basic examples and gradually progress to advanced scenarios as you become more comfortable with Azure and Terraform! 