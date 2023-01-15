# terraform.aws

Let's build a basic dev environment:

Setup
- Procure access key from AWS management console to allow programmatic access
- Grant admin access to the IAM user
- Download the AWS extension for VS Code
- Paste in the access key credentials from IAM .csv file
- Download Terraform extension for VS Code
- Navigate to 'AWS Provider' info on Terraform website
- Copy code to add AWS as provider

Let's get building
- Deploy the VPC
- Configure networking for the VPC
- To view the VPC & network info, navigate to AWS pane > Resources
- Create a public subnet within the VPC
- Create an IGW and route table, associate to the subnet
