/*
# CRIAÇÃO KMS KEY

# deletion_window_in_days – (Opcional) O período de espera, especificado em número de dias. Depois que o período de espera terminar,
# AWS KMS exclui a chave KMS. Se você especificar um valor, ele deverá estar entre 7 e 30, inclusive. Se você não especificar um valor,
# o padrão é 30. Se a chave KMS for uma chave primária multirregional com réplicas,
# o período de espera começa quando a última chave de réplica é excluída. Caso contrário, o período de espera começa imediatamente.

*/

# Configurando policy similar ao que temos no aws backup feita na mao, pensando em cross account

resource "aws_kms_key" "backup_kms_key" {

  description = join("-", [var.customer_env, "KMS-Key-BackupJairo", var.AWS_REGION])
  tags = {
    Backup = "aws-backup"
    Name   = "${var.project_name}-kmskey"
  }
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
                    "arn:aws:iam::${local.source_account_number}:root"
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
                    "arn:aws:iam::${local.source_account_number}:root"
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
}



# Recurso somente para nomear o kms key
# name prefix  é um argumento do recurso aws_kms_alias. Ele define um prefixo para o nome do alias.
# name_prefix Este é outro argumento do recurso aws_kms_alias. Ele especifica o ID da chave KMS à qual o alias será direcionado.
# No exemplo, o valor é obtido referenciando o key_id do recurso aws_kms_key criado anteriormente (aws_kms_key.backup_kms_key.key_id).

resource "aws_kms_alias" "backup_kms_key_jairo" {

  name_prefix   = "alias/backup_kms_key/"
  target_key_id = aws_kms_key.backup_kms_key.key_id
}