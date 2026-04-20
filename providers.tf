terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.41.0"
    }
  }
}

provider "aws" {
  access_key = var.acc
  secret_key = var.se

	region	=	var.reg

}
