/*


# CRIAÇÃO KMS KEY

# - (Optional) The description of the key as viewed in AWS console.

# deletion_window_in_days - (Optional) The waiting period, specified in number of days. After the waiting period ends, 
# AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value,
# it defaults to 30. If the KMS key is a multi-Region primary key with replicas, 
# the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately.

*/

# Configurando policy similar ao que temos no aws backup feita na mao, pensando em cross account

resource "aws_kms_key" "backup_kms_key" {

  description = join("-", [var.customer_env, "KMS-Key-BackupJairo", var.AWS_REGION])
  # especifica o período de espera para exclusão da chave KMS após ser agendada para exclusão. No exemplo, a janela de exclusão é de 10 dias.
  deletion_window_in_days = 10
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


