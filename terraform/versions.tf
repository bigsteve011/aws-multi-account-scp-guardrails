terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Run from the Organizations management account (or a delegated policy administrator).
provider "aws" {
  region = "us-east-1"
}
