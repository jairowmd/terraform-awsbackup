# Módulo para monitoramento de falhas de backup com SNS e EventBridge

# Configuração do SNS Topic para monitoramento de falhas de backup
resource "aws_sns_topic" "sns_topic_for_alerts" {
  name = "AWSBackup-Alerts"
}

# Política do tópico SNS para permitir publicações de AWS Backup e EventBridge
resource "aws_sns_topic_policy" "topic_policy" {
  arn = aws_sns_topic.sns_topic_for_alerts.arn
  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "BackupPolicy"
    Statement = [
      {
        Sid       = "AllowEventBridgeToPublish"
        Effect    = "Allow"
        Principal = { Service = "events.amazonaws.com" }
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.sns_topic_for_alerts.arn
      },
      {
        Sid       = "AllowPublishFromAWSBackup"
        Effect    = "Allow"
        Principal = { Service = "backup.amazonaws.com" }
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.sns_topic_for_alerts.arn
      }
    ]
  })
}

# Inscrição no SNS para endpoint HTTPS (exemplo: OpsGenie)
resource "aws_sns_topic_subscription" "http_target" {
  topic_arn = aws_sns_topic.sns_topic_for_alerts.arn
  protocol  = "https"
  endpoint  = local.opsgenie_endpoint
}

# Regra do EventBridge para monitorar falhas de jobs de backup no AWS Backup
resource "aws_cloudwatch_event_rule" "backup_failure_rule" {
  name        = "AWSBackupFailureNotifications"
  description = "Captura eventos de falha em jobs de backup, restore e cópia do AWS Backup"

  event_pattern = jsonencode({
    "source": ["aws.backup"],
    "detail-type": ["Backup Job State Change", "Restore Job State Change", "Copy Job State Change"],
    "detail": {
      "state": ["FAILED"]
    }
  })
}

# Conecta a regra do EventBridge ao tópico SNS para enviar alertas
resource "aws_cloudwatch_event_target" "send_to_sns" {
  rule      = aws_cloudwatch_event_rule.backup_failure_rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.sns_topic_for_alerts.arn
}
