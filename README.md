# 🚀 Terraform Learning Repository

Welcome to my comprehensive Terraform learning and practice repository! This repository contains custom modules, examples, and best practices for Infrastructure as Code (IaC) using Terraform.

## 📋 Overview

This repository serves as a centralized location for:
- Learning and practicing Terraform concepts
- Developing reusable Terraform modules
- Exploring different cloud providers and services
- Implementing Infrastructure as Code best practices

## 🏗️ Modules

You'll find custom modules developed for various cloud providers and use cases:

### Available Providers
- 🔵 **[AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)** - Amazon Web Services modules (Learning)
- ☁️ **[Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)** - Microsoft Azure modules  
- 🌐 **[OCI](https://registry.terraform.io/providers/oracle/oci/latest/docs)** - Oracle Cloud Infrastructure
- 🔧 **Multi-Cloud** - Provider-agnostic modules

### Module Categories 
- **Networking** - VPCs, subnets, security groups
- **Compute** - Virtual machines, containers, serverless
- **Storage** - Databases, object storage, file systems
- **Security** - IAM, encryption, monitoring
- **DevOps** - CI/CD, monitoring, logging

## 📚 Documentation

I'm using [**Terraform Docs**](https://terraform-docs.io/) to automatically generate comprehensive documentation for each module, including:

- 📝 **Module Descriptions** - Purpose and functionality
- 🔧 **Input Variables** - Required and optional parameters
- 📤 **Output Values** - Resources and data returned
- 📋 **Requirements** - Provider versions and dependencies
- 💡 **Usage Examples** - Real-world implementation examples

## 🛠️ Getting Started

### Prerequisites
```bash
# Install Terraform
terraform --version

# Install terraform-docs (for documentation)
terraform-docs --version
```

### Quick Start
```bash
# Clone the repository
git clone <repository-url>
cd terraform

# Navigate to a module
cd modules/<module-name>

# Review the documentation
cat README.md

# Initialize and plan
terraform init
terraform plan
```

## 📁 Repository Structure

```
terraform/
├── modules/
│   ├── aws/
│   │   ├── vpc/
│   │   ├── ec2/
│   │   └── s3/
│   ├── azure/
│   │   ├── resource-group/
│   │   ├── vm/
│   │   └── storage/
│   └── oci/
│       ├── network/
│       ├── compute/
│       └── storage/
├── examples/
│   ├── basic/
│   ├── advanced/
│   └── real-world/
├── docs/
│   ├── best-practices.md
│   ├── troubleshooting.md
│   └── contributing.md
└── README.md
```

## 🎯 Best Practices

- ✅ **Version Control** - All modules are version tagged
- 🔒 **Security First** - Security scanning and compliance checks
- 📖 **Documentation** - Comprehensive docs for all modules
- 🧪 **Testing** - Automated testing with Terraform test
- 🔄 **CI/CD** - Automated validation and deployment
- 📊 **State Management** - Remote state with proper backends

<!-- ## 🤝 Contributing

Contributions are welcome! Please read the [Contributing Guidelines](./docs/contributing.md) before submitting pull requests.

## 📞 Support

If you have questions or need help:
- 📖 Check the [Documentation](./docs/)
- 🐛 Open an [Issue](../../issues)
- 💬 Start a [Discussion](../../discussions) -->

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

⭐ **Star this repository** if you find it helpful for your Terraform journey! 