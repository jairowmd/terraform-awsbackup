/*
 Definindo backup plans:

   * Com que frequência os backups são criados?

* Por quantos dias estamos armazenando os backups?

Também defina tags para selecionar quais recursos são aplicados a cada plano de backup.

A documentação sobre como escrever as expressões cron está aqui [0], observe
que ela usa um formato ligeiramente diferente do cron do Linux.

[0] https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
*/
resource "aws_backup_plan" "Backup_diario_exceto_domingo" {
  name = "Backup_diario_exceto_domingo"
  rule {
    rule_name         = "Backup_diario_exceto_domingo"
    target_vault_name = aws_backup_vault.backup_vault.name

    # todos os dias, exceto domingos (índice de dia 1), às 3 da manhã
    # domingos não estão incluídos aqui para evitar duplicatas com o
    # plano de backup semanal
    # Custom cron expression: cron(0 3 ? * 2-7 *)
    # At 03:00 AM Etc/UTC (UTC+00:00), Monday through Saturday

    schedule = "cron(0 3 ? * 2-7 *)"

    lifecycle {
      # Keep daily backups for 7 days
      delete_after = "7"

      # Can't use cold_storage_after here because data needs to be stored there
      # for at least 90 days
      #
      # cold_storage_after = "..."
    }
  }
}

