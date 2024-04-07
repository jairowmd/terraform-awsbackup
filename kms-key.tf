/*


# CRIAÇÃO KMS KEY

# - (Optional) The description of the key as viewed in AWS console.

# deletion_window_in_days - (Optional) The waiting period, specified in number of days. After the waiting period ends, 
# AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value,
# it defaults to 30. If the KMS key is a multi-Region primary key with replicas, 
# the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately.

*/

resource "aws_kms_key" "backup_kms_key" {

  description = join("-", [var.customer_env, "KMS-Key-BackupJairo", var.AWS_REGION])
  # especifica o período de espera para exclusão da chave KMS após ser agendada para exclusão. No exemplo, a janela de exclusão é de 10 dias.
  deletion_window_in_days = 10
  tags = {
    Backup = "aws-backup"
    Name   = "${var.project_name}-kmskey"
  }
}


# Recurso somente para nomear o kms key
resource "aws_kms_alias" "backup_kms_key_jairo" {
  # name prefix  é um argumento do recurso aws_kms_alias. Ele define um prefixo para o nome do alias. 
  name_prefix = "alias/backup_kms_key/"
  # Este é outro argumento do recurso aws_kms_alias. Ele especifica o ID da chave KMS à qual o alias será direcionado.
  # No exemplo, o valor é obtido referenciando o key_id do recurso aws_kms_key criado anteriormente (aws_kms_key.backup_kms_key.key_id).
  target_key_id = aws_kms_key.backup_kms_key.key_id
}


# https://www.pulumi.com/ai/answers/njr8K9DhaPnchH4Yj44BLp/creating-an-aws-kms-alias-with-terraform

# To create an AWS Key Management Service (KMS) alias with Terraform, you will use the aws_kms_key and aws_kms_alias resources.

# The aws_kms_key resource creates a new KMS key that you can use to encrypt and decrypt data. 
# The description and key_usage arguments define it as a general-purpose KMS key.
# The aws_kms_alias resource creates an alias for the KMS key. 
# The name_prefix argument is used to create a unique alias that starts with a specified prefix. target_key_id is the ID of
# the key defined in aws_kms_key to make sure the alias points to it.