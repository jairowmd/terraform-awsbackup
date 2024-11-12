
# Criando vaults 

# Criado um vault simples
resource "aws_backup_vault" "backup_vault" {
  name        = "backup_vault_${var.project_name}"
  kms_key_arn = aws_kms_key.backup_kms_key.arn
  tags = {
    Backup = "aws-backup"
    Name   = "${var.project_name}-aws-backup-vault"
  }

}


# Criado um segundo vault 
resource "aws_backup_vault" "backup_vault_2" {
  name        = "backup_vault_2${var.project_name}"
  kms_key_arn = aws_kms_key.backup_kms_key.arn
  tags = {
    Backup = "aws-backup"
    Name   = "${var.project_name}-aws-backup-vault"
  }

}