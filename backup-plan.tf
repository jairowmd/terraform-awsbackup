# O arquivo backup-plan.tf define um plano de backup para uma conta AWS.
# Plano de backup diario exceto domingo.

# Backup Plan - Define um plano de backup chamado "Backup_diario_exceto_domingo".
resource "aws_backup_plan" "Backup_diario_exceto_domingo" {
  name = "Backup_diario_exceto_domingo" # Nome do plano de backup para identificação no AWS.

  rule {
    rule_name         = "Backup_diario_exceto_domingo" # Nome da regra de backup.
    target_vault_name = aws_backup_vault.backup_vault.name # Nome do cofre de backup de destino para armazenar backups.

    # schedule - Define a frequência do backup usando uma expressão cron personalizada.
    # Este cron configura o backup para ocorrer todos os dias (segunda a sábado) às 03:00 AM UTC,
    # evitando duplicação com outro plano de backup semanal.
    schedule = "cron(0 3 ? * 2-7 *)"
    start_window = 480 # Tempo máximo de espera para o início do backup (8 horas, em minutos).
    completion_window = 10080 # Tempo máximo permitido para a conclusão do backup (7 dias, em minutos).

    # copy_action - Configura uma ação de cópia para armazenar uma cópia do backup em um cofre de longo prazo.
    copy_action {
      destination_vault_arn = local.destination_vault # ARN do cofre de destino para a cópia de retenção estendida.

      lifecycle {
        delete_after = "10" # A cópia é mantida por 10 dias antes de ser excluída.
      }
    }

    lifecycle {
      # Define a retenção para os backups diários criados por esta regra.
      delete_after = "7" # Retém o backup por 7 dias antes de exclusão automática.
    }
  }
}

# Backup Selection - Define os recursos incluídos neste plano de backup com base em tags.
resource "aws_backup_selection" "Backup_diario_exceto_domingo_selection" {
  plan_id      = aws_backup_plan.Backup_diario_exceto_domingo.id # Associa esta seleção ao plano de backup diário.
  name         = "backup_selection" # Nome da seleção de backup para referência.
  
  # Função IAM que concede permissões para o AWS Backup acessar e realizar backups dos recursos selecionados.
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"

  # selection_tag - Critério de filtro para incluir recursos neste backup.
  # Apenas recursos com a tag "Backup_diario_10_D" com valor "True" serão incluídos neste plano.
  selection_tag {
    type  = "STRINGEQUALS" # Especifica que o valor da tag deve ser uma correspondência exata.
    key   = "Backup_diario_10_D" # Nome da tag utilizada para identificar os recursos a serem incluídos.
    value = "True" # Valor da tag que indica que o recurso deve ser incluído no backup.
  }
}
