/*
 Backup strategy for multiple resource types, including RDS and DynamoDB,
 usign AWS Backup.
*/

# Criado um vault simples
resource "aws_backup_vault" "backup_vault" {
  name        = "backup_vault_${var.project_name}"
  kms_key_arn = aws_kms_key.backup_kms_key.arn
  tags = {
    Backup = "aws-backup"
    Name   = "${var.project_name}-aws-backup-vault"
  }

}
