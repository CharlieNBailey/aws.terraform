terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "/Users/chaz/.aws/credentials"
  profile                 = "vscode"
}