# terraform-feature-stacks

## The Why

1. Are you a software developer or do you work with software developers who make changes to applications hosted in AWS?
2. Would you like to have ephemeral cloud environments that match your Dev environment configuration where you can test your code before merging features to the `main` branch?
3. Are you working with GitHub actions to provision infrastructure and deploy your applications?

If you answered yes to these questions, then you may find this repository helpful.

This repo serves as an example of one way you can use Terraform to deploy unique resources for feature branches. The goal is to give developers real AWS resources to test in before merging their Pull Request and breaking the Dev environment.

In this example, we have a full set of resources that will be deployed to the Dev environment. Some of those resources might be costly or time consuming, so we may want to share them with the ephemeral environments, rather than spend the time or money to create a full set of resources. For those resources we will deploy from feature branches, we are referring to this group of resources as a `feature stack`.

For our purposes, we will borrow the definition of a `stack` from Terramate: "A stack is a collection of infrastructure resources that you configure, provision and manage as a unit." These are collections of resources that can, and often should, be organized and deployed separately. For example, you may have a VPC stack that is responsible for all of your network infrastructure. You could organize your Terraform to contain all infrastructure in the same module, but if you only make changes to a lambda as part of your API, there is potential to unintentionally make a change that affects your VPC resources. It's my preference to create a separation of concerns to minimize the blast radius when making changes to Terraform resources. This also has the benefit of speeding up the provisioning process when a smaller set of infrastructure is being planned and provisioned.

## AWS Infrastructure

See [./infra/README.md](./infra/README.md) for more details on the infrastructure setup.

## Source Code

We are using two simple example lambdas behind an API Gateway. The first lambda (`<api-gateway-invoke-url>/download`) will download [HTTP Cats](https://http.cat/) images based off a supplied status code. The second lambda (`<api-gateway-invoke-url>/reverse`) will download an image from S3, flip the image horizontally, then save it back to S3.

These Python lambdas can be triggered via a POST request with a body like `{"StatusCode": "401"}` (use `{"body": "{\"StatusCode\": \"401\"}"}` in Lambda test console). If no `"StatusCode"` property is found on the event's body object, the status code will default to a "200".

## Example Project Setup

1. //TODO

//TODO: Investigate LocalStack and add instructions on how to run locally.
