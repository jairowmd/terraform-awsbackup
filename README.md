# Projeto AWS Backup com vault lock

## Descrição

Este projeto visa criar uma estrutura de backup de curto e longo prazo utilizando `vault lock` para múltiplos recursos da AWS, incluindo RDS e DynamoDB, através do serviço AWS Backup. O projeto utiliza o Terraform para criar e gerenciar os recursos da AWS.

## Requisitos

- Conta AWS com permissões para criar recursos
- Terraform instalado e configurado
- AWS CLI instalado e configurado

## Recursos

Os seguintes recursos são configurados no projeto:

- **AWS Backup Plan**: Plano de backup com backups diários, semanais e mensais.
- **AWS Backup Selection**: Seleção de recursos a serem backupados.
- **Tags**: Tags para identificar os recursos de backup.
- **AWS Backup Vault**: Dois vaults para armazenamento de backups.
- **Políticas de Vault**: Controle de acesso e retenção de backups nos vaults.
- **Vault Lock**: Controle de acesso e retenção dos backups nos vaults.
- **AWS KMS Key**: Chave KMS para criptografia dos backups.
- **Monitoramento**: Políticas de monitoramento para alertas sobre falhas de backup e restauração via Opsgenie.

## Arquivos

- `backup-plan.tf`: Plano de backup com cronograma para backups diários, semanais e mensais.
- `data.tf`: Dados do projeto, incluindo informações da conta e região AWS.
- `kms-key.tf`: Configuração da chave KMS para criptografia.
- `monitoramento.tf`: Políticas de monitoramento de falhas de backup e restauração.
- `output.tf`: Saídas do projeto, incluindo IDs dos recursos criados.
- `provider.tf`: Configuração do provedor AWS.
- `terraform.tfvars`: Variáveis do projeto, incluindo o nome do projeto e a região.
- `vars.tf`: Variáveis do projeto, incluindo nome e região.
- `vault-lock.tf`: Configuração de `vault lock` para controle de acesso e retenção dos backups.
- `vault.tf`: Configuração do cofre de backup para armazenamento dos backups.

## Como usar

1. Clone o repositório: `git clone https://github.com/seu-usuario/projeto-backup-aws.git`
2. Instale as dependências: `terraform init`
3. Configure as variáveis: `terraform apply -var project_name=seu-projeto`
4. Crie os recursos: `terraform apply`

## Variáveis
* As seguintes variáveis são utilizadas no projeto:

* `project_name`: Nome do projeto.
* `region`: Região AWS para a criação dos recursos.

## Dependências
* `locals.tf`: Variáveis para uso em vários locais do projeto.
* `source_account_number`: Número da conta AWS utilizado no arquivo `vault-lock.tf`.
* `destination_vault`: Identificação do primeiro vault usado no `backup-plan`.
* `destination_vault_2`: Identificação do segundo vault usado no `backup-plan`.
* `opsgenie_endpoint`: Endpoint Opsgenie para monitoramento.

* Exemplo de configuração:

* `locals` {
   source_account_number = "xxxxxxxx"
   destination_vault = "arn:aws:backup:us-east-1:xxxxxx:backup-vault:backup_vault_awsbackup-development"
   destination_vault_2 = "arn:aws:backup:us-east-1:xxxxxx:backup-vault:backup_vault_2awsbackup-development"
   opsgenie_endpoint = "https://api.opsgenie.com"
 }



* `terraform.tfvars`: variáveis que podem ser usadas em vários lugares do projeto, sem precisar serem passadas como argumentos.
	* project name utilizada para nomear recursos
	* project_name = "awsbackup-development"


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