# Arquivo para configuração das versões dos providers que vamos usar, como a aws e a própria versão do terraform


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }

  # Essa impostação do TFstate so vai funcionar se existir o bucket com o nome descrito. 
  # configurando onde vai ficar o tfstate compartilhado - executar um terraform init novamente logo apos
  # terraform init -migrate-state 
  # backend "s3" {

  # bucket = "backend-terraform-jwmd"
  # key    = "dev/terraform.tfstate"
  # region = "us-east-1"

  #}

}

# VARIAVEL DA REGIAO DO PROVISIONAMENTO DOS RECURSOS em vars.tf
provider "aws" {
  region = var.AWS_REGION
}