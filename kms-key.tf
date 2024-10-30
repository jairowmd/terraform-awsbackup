
# CRIAÇÃO KMS KEY

resource "aws_kms_key" "backup_kms_key" {
  description = join("-", [var.customer_env, "KMS-Key-BackupJairo", var.AWS_REGION])
  # Cria uma chave KMS com uma descrição concatenada a partir das variáveis 'customer_env', uma string fixa "KMS-Key-BackupJairo" e a variável 'AWS_REGION'.

  tags = {
    Backup = "aws-backup"
    Name   = "${var.project_name}-kmskey"
  }
  # Adiciona tags à chave KMS para identificação. A tag 'Backup' é fixa e a tag 'Name' é concatenada a partir da variável 'project_name' e a string "-kmskey".

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Allow access for Key Administrators",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action": [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:ReplicateKey",
          "kms:UpdatePrimaryRegion"
        ],
        "Resource": "*"
      },
      {
        "Sid": "Allow use of the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          ]
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        "Resource": "*"
      },
      {
        "Sid": "Allow attachment of persistent resources",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          ]
        },
        "Action": [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource": "*",
        "Condition": {
          "Bool": {
            "kms:GrantIsForAWSResource": "true"
          }
        }
      }
    ]
  }
  EOF
  # Define a política da chave KMS utilizando múltiplas declarações (statements) com permissões específicas:
  # - 'Enable IAM User Permissions' permite todas as ações de KMS para o usuário root da conta atual.
  # - 'Allow access for Key Administrators' permite ações administrativas específicas na chave para o usuário root.
  # - 'Allow use of the key' permite o uso da chave para serviços de backup específicos e para o usuário root.
  # - 'Allow attachment of persistent resources' permite a criação e gestão de grants para recursos persistentes, condicionada a ser para recursos AWS.
}


# Recurso somente para nomear o kms key
# name prefix  é um argumento do recurso aws_kms_alias. Ele define um prefixo para o nome do alias.
# name_prefix Este é outro argumento do recurso aws_kms_alias. Ele especifica o ID da chave KMS à qual o alias será direcionado.
# No exemplo, o valor é obtido referenciando o key_id do recurso aws_kms_key criado anteriormente (aws_kms_key.backup_kms_key.key_id).

resource "aws_kms_alias" "backup_kms_key_jairo" {

  name_prefix   = "alias/backup_kms_key/"
  target_key_id = aws_kms_key.backup_kms_key.key_id
}