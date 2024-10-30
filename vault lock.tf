
# Configura o Vault Lock no Backup Vault
resource "aws_backup_vault_lock_configuration" "vault_lock" {
  backup_vault_name = aws_backup_vault.backup_vault_2.name

  # Período de retenção mínima em dias (1 é o mínimo)
  min_retention_days = 1

  # Período de retenção máxima em dias
  max_retention_days = 3650

  # Bloqueio de Imutabilidade (Opcional)
  # Se habilitado, impede a remoção de políticas de bloqueio
  changeable_for_days = 3000 # Tempo que a política de bloqueio pode ser alterada
}

# Opcional: Define a política do Vault
resource "aws_backup_vault_policy" "vault_policy" {
  backup_vault_name = aws_backup_vault.backup_vault_2.name
  policy            = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Allow Cross-Account Backup",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${local.source_account_number}:root"
        },
        "Action": [
          "backup:CopyIntoBackupVault",
          "backup:PutBackupVaultAccessPolicy",
          "backup:PutBackupVaultNotifications"
        ],
        "Resource": "*"
      }
    ]
  }
  POLICY
}