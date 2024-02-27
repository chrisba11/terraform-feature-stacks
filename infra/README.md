# Infrastructure Directory Documentation

## Overview

The `infra` directory is integral to our project's infrastructure as code (IaC) strategy, containing configurations for both AWS CloudFormation and Terraform. This directory is organized to facilitate the management of cloud resources, with a clear separation between the initial setup of Terraform state resources (CloudFormation) and the management of the remaining infrastructure (Terraform).

## Directory Structure

```
infra/
├── cfn/
│   └── CloudFormation templates
└── tf/
    ├── modules/
    │   └── Terraform local module directories
    ├── stacks/
    │   ├── api/
    │   │   └── Terraform configuration files
    │   ├── oidc/
    │   │   └── Terraform configuration files
    │   ├── storage/
    │   │   └── Terraform configuration files
    │   └── vpc/
    │       └── Terraform configuration files
    └── .terraform-docs.yml
```

### The `cfn` Directory

This directory houses a AWS CloudFormation template responsible for setting up foundational resources necessary for Terraform state management. These include S3 buckets for state files, DynamoDB tables for state locking, and necessary IAM policies and roles.

### The `tf` Directory

The `tf` directory contains all Terraform configurations, organized into modular stacks within the `stacks` subdirectory. The term 'stack' here is not to be confused with the new Terraform 'stacks' feature that is currently in preview. Each stack represents a logical group of resources, such as network infrastructure (`vpc`), application services (`api`), or authentication mechanisms (`oidc`).

### The `tf/stacks` Subdirectory

Inside the `tf/stacks` directory, you'll find different stacks that categorize our infrastructure resources into distinct, manageable units. This organizational approach offers several key benefits:

1. **Reduced Blast Radius**: By dividing our Terraform configurations into separate stacks, we minimize the 'blast radius' of unintended changes. Changes made within one stack are isolated from others, reducing the risk of accidental impacts across the broader infrastructure. This is especially critical in large-scale environments where a small change can have far-reaching consequences if not properly isolated.
2. **Focused Resource Management**: Each stack is focused on a specific application, service, or conceptual aspect of our infrastructure. This separation of concerns means that each stack contains only the resources that are directly related to its specific function. For example, a `vpc` stack would solely manage network-related resources, while an `api` stack would handle resources specific to a set of APIs.
3. **Easier Maintenance and Scalability**: Stacks make it easier to manage and scale our infrastructure. By dealing with smaller, logically grouped sets of resources, we can more easily understand, update, and maintain our configurations. This also facilitates quicker onboarding of new team members, as they can focus on specific areas without being overwhelmed by the entire infrastructure.
4. **Enhanced Collaboration and Parallel Development**: With distinct stacks, multiple team members or teams can work on different aspects of the infrastructure simultaneously without stepping on each other's toes. This parallel development capability enhances productivity and accelerates deployment cycles.
5. **Streamlined Testing and Deployment**: Smaller, self-contained stacks enable more targeted testing and quicker deployments. It's easier to test and validate changes when they are confined to a specific area of the infrastructure, leading to more reliable deployments.

By embracing this stacked approach in the `tf/stacks` directory, we achieve a more robust, manageable, and scalable infrastructure, ensuring that our Terraform code remains clear, organized, and efficient. This methodology aligns with best practices in infrastructure management, contributing significantly to the overall resilience and agility of our cloud environment.

#### Terraform Documentation Automation

To ensure up-to-date and consistent documentation of our Terraform stacks, we employ the `terraform-docs` package. A script located at [../scripts/update-tf-docs.sh](../scripts/update-tf-docs.sh) automates the process of generating documentation for each stack. This script scans through the stacks in the `tf/stacks` directory and generates documentation accordingly, leveraging the configuration defined in [./tf/.terraform-docs.yml](./tf/.terraform-docs.yml).

##### `update_tf_docs.sh` Script

Here's a brief overview of how the script works:

- It identifies all stack directories within `tf/stacks`.
- For each stack, it runs `terraform-docs` to update the documentation based on the current state of the Terraform configurations.
- The script outputs the paths of the stacks it processed, providing a summary of the documentation update operation.

This automation ensures our Terraform documentation is always aligned with the current state of our infrastructure code, enhancing clarity and accessibility for the team.

## Workflow

1. **CloudFormation Initialization**: Use the `cfn` directory to set up Terraform state management resources within AWS.
2. **Terraform Implementation**: Manage and provision the majority of infrastructure via the Terraform stacks in the `tf/stacks` directory.
3. **Documentation Updates**: Regularly run the `update-tf-docs.sh` script to keep Terraform documentation in sync with the current configurations.

## Best Practices

- **Version Control and Frequent Commits**: Regularly commit changes to the IaC files for collaboration and history tracking.
- **Clear Documentation**: Ensure that configurations are well-documented, clearly explaining each resource's purpose and design.
- **Review and Testing**: Regularly review and test configurations to maintain alignment with project requirements and best practices.
