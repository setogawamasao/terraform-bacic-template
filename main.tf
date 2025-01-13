terraform {
  // Terraformのバージョン制約  
  required_version = "~> 1.10.4"
  // プロバイダのバージョン制約  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83"
    }
  }
}

// プロバイダの認証情報を環境変数から取得
variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "AWS_SESSION_TOKEN" {
  type = string
}

provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
  region     = "ap-northeast-1"
}

//　定数
locals {
  project-name = "setotogawa-test"
}
