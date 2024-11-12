

**Projeto de Backup com AWS Backup**

**Descrição**

Este projeto visa criar uma estrutura de backup de curta e longa retenção utilizando vault lock para múltiplos recursos da AWS, incluindo RDS e DynamoDB, utilizando o serviço AWS Backup. O projeto utiliza o Terraform para criar e gerenciar os recursos da AWS.

**Requisitos**

* Conta AWS com permissões para criar recursos
* Terraform instalado e configurado
* AWS CLI instalado e configurado

**Arquitetura**

A arquitetura do projeto consiste em:

* **Vaults**: Dois vaults são criados para armazenar os backups:
	+ `backup_vault`: O primeiro vault é criado com o nome `backup_vault_${var.project_name}` e é utilizado para armazenar os backups dos recursos pensando em curta retenção.
	+ `backup_vault_2`: O segundo vault é criado com o nome `backup_vault_2${var.project_name}` e é utilizado para armazenar os backups dos recursos pensando em longa retenção com vault lock.

* **Chave KMS**: Uma chave KMS é criada para criptografar os backups.

* **Políticas de Vault**: As políticas de vault são definidas para controlar o acesso e a retenção dos backups nos vaults.

**Recursos**

Os seguintes recursos são criados no projeto:

* **AWS Backup Vault**: Dois vaults são criados para armazenar os backups.
* **AWS KMS Key**: Uma chave KMS é criada para criptografar os backups.
* **Políticas de Vault**: As políticas de vault são definidas para controlar o acesso e a retenção dos backups nos vaults.
* **Monitoramento** As políticas de Monitoramento são definidas para monitorar as falhas de backup e restore.

**Como usar**

1. Clone o repositório: `git clone https://github.com/seu-usuario/projeto-backup-aws.git`
2. Instale as dependências: `terraform init`
3. Configure as variáveis: `terraform apply -var project_name=seu-projeto`
4. Crie os recursos: `terraform apply`

**Variáveis**

As seguintes variáveis são utilizadas no projeto:

* `project_name`: O nome do projeto.
* `region`: A região da AWS onde os recursos serão criados.

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