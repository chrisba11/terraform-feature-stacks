# terraform-feature-stacks

This serves as an example of one way you can use Terraform to deploy unique resources for feature branches. The goal is to give developers real cloud provider resources to test in prior to merging their code in to the `main` or `dev` branch.

In this example, we have some resources that are shared and will not be deployed for feature branches. For those resources we will deploy, we are referring to the group of resources as a `feature stack`.

For our purposes, we will borrow the definition of a stack from Terramate: "A stack is a collection of infrastructure resources that you configure, provision and manage as a unit." These are collections of resources that can, and and often should, be organized and deployed separately. For example, you may have a VPC stack that is responsible for all of your network infrastructure. You could organize your Terraform to contain all infrastructure in the same module, but if you only make changes to a lambda as part of your API, there is potential to unintentionally make a change that affects your VPC resources. It's my preference to create a separation of concerns to minimize the blast radius when making changes to Terraform resources. This also has the benefit of speeding up the provisioning process when a smaller set of infrastructure is being planned.

## AWS Infrastructure

See [./infra/README.md](./infra/README.md) for more details on the infrastructure setup.

## Source Code

We are using a simple example lambda that will download [HTTP Cats](https://http.cat/) images based off a supplied status code. This Python lambda can be triggered via a POST request to an API Gateway endpoint with a body like `{"StatusCode": "401"}`. If no `"StatusCode"` property is found on the body object, the code will default to a "200".
