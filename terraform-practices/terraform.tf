terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.38.0"
    }
  }

  backend "s3"{
    bucket="hjinfotech-remote-bucket"
    dynamodb_table="hjinfotech-remote-table"
    key="terraform.tfstate"
    region = "eu-west-1"
}
}