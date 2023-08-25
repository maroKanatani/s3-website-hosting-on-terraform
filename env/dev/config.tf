terraform {
  required_version = "1.5.3"

  required_providers {
    aws = {
      version = "5.8.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "terraform-state-20230622130934663800000001"
    key    = "trial/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
