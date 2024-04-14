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


# configuração da politica do vault  
resource "aws_backup_vault_policy" "novo_backup_vault_policy" {
  backup_vault_name = aws_backup_vault.backup_vault.name
  policy            = <<POLICY
    {
   "Version": "2012-10-17",
   "Id": "default",
   "Statement": [
     {
       "Sid": "Allow Tool Prod Account to copy into backup_vault",
       "Effect": "Allow",
       "Action": "backup:CopyIntoBackupVault",
       "Resource": "*",
       "Principal": {
         "AWS": "arn:aws:iam::${local.source_account_number}:root"
       }
     }
   ]
 }
 POLICY
}