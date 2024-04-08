# Arquivo para configuração das versões dos providers que vamos usar, como a aws e a própria versão do terraform


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }  
  }

  # configurando onde vai ficar o tfstate compartilhado - executar um terraform init novamente logo apos
  # terraform init -migrate-state 
    backend "s3" {

      bucket = "backend-terraform-jwmd"
      key = "dev/terraform.tfstate"
      region = "us-east-1"

    }

}


provider "aws" {
  region = var.AWS_REGION
}