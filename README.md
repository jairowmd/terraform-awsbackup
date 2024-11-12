

**Projeto de Backup com AWS Backup**

**Descrição**

Este projeto visa criar uma estrutura de backup de curto e longo prazo utilizando vault lock para múltiplos recursos da AWS, incluindo RDS e DynamoDB, utilizando o serviço AWS Backup. O projeto utiliza o Terraform para criar e gerenciar os recursos da AWS.

**Requisitos**

* Conta AWS com permissões para criar recursos
* Terraform instalado e configurado
* AWS CLI instalado e configurado

**Recursos**

Os seguintes recursos são criados no projeto:

* **AWS Backup Plan**: Um plano de backup é criado para criar backups diários, semanais e mensais.
* **AWS Backup Selection**: Uma seleção de recursos é criada para incluir os recursos a serem backupados.
* **Tags**: As tags são utilizadas para identificar os recursos a serem backupados.
* **AWS Backup Vault**: Dois vaults são criados para armazenar os backups.
* **Políticas de Vault**: As políticas de vault são definidas para controlar o acesso e a retenção dos backups nos vaults.
* **Vault Lock**: Um vault lock é criado para controlar o acesso e a retenção dos backups nos vaults.
* **AWS KMS Key**: Uma chave KMS é criada para criptografar os backups.
* **Monitoramento** As políticas de Monitoramento são definidas para monitorar as falhas de backup e restore com o opsgenie.

* **Arquivos:**
	backup-plan.tf: Este arquivo contém o plano de backup para criar backups diários, semanais e mensais.
	data.tf: Este arquivo contém os dados utilizados no projeto, incluindo informações sobre a conta AWS e a região da AWS.
	kms-key.tf: Este arquivo contém a configuração da chave KMS utilizada para criptografar os backups.
	monitoramento.tf: Este arquivo contém as políticas de monitoramento para monitorar as falhas de backup e restore.
	output.tf: Este arquivo contém as saídas do projeto, incluindo o ID dos recursos criados.
	provider.tf: Este arquivo contém a configuração do provedor da AWS.
	terraform.tfvars: Este arquivo contém as variáveis utilizadas no projeto, incluindo o nome do projeto e a região da AWS.
	vars.tf: Este arquivo contém as variáveis utilizadas no projeto, incluindo o nome do projeto e a regulação da AWS.
	vault lock.tf: Este arquivo contém a configuração do vault lock para controlar o acesso e a retenção dos backups nos vaults.
	vault.tf: Este arquivo contém a configuração do cofre de backup para armazenar os backups.

**Como usar**

1. Clone o repositório: `git clone https://github.com/seu-usuario/projeto-backup-aws.git`
2. Instale as dependências: `terraform init`
3. Configure as variáveis: `terraform apply -var project_name=seu-projeto`
4. Crie os recursos: `terraform apply`

**Variáveis**

As seguintes variáveis são utilizadas no projeto:

* `project_name`: O nome do projeto.
* `region`: A região da AWS onde os recursos serão criados.

**Dependências**

* locals.tf: variáveis que podem ser usadas em vários lugares do projeto, sem precisar serem passadas como argumentos.
	Informar aqui identificação do vault utilizado no arquivo backup-plan -  destination_vault
	Informar aqui identificação do vault utilizado no arquivo backup-plan -  destination_vault_2
	informar aqui identificação do opsgenie utilizado no arquivo monitoramento - opsgenie_endpoint
	informar aqui número da conta AWS que vamos utilizar utilizada no arquivo vault lock.tf - source_account_number

locals {
  source_account_number = ""
}

#Informar nome do vault 1
locals {
  destination_vault = "arn:aws:backup:us-east-1:xxxxxx:backup-vault:backup_vault_awsbackup-development"
}


#Informar nome do vault 2
locals {
  destination_vault_2 = "arn:aws:backup:us-east-1:xxxxx:backup-vault:backup_vault_2awsbackup-development"
}


locals {
  
  opsgenie_endpoint = "https://xxxxxxx"

}



**Contribuições**

Contribuições são bem-vindas! Se você tiver alguma sugestão ou correção, por favor, abra um issue ou faça um pull request.

**Licença**

Este projeto é licenciado sob a licença MIT.

**Autores**

* Jairo Domingues

**Changelog**

* 1.0.0: Versão inicial do projeto

**Issues**

* Se você encontrar algum problema, por favor, abra um issue no repositório.

**Pull Requests**

* Se você tiver alguma sugestão ou correção, por favor, faça um pull request no repositório.