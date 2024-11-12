# Arquivo de saida do terraform
# utilizado para mostrar variaveis e requests na tela antes do apply
# estou usando com o data

output "aws_region" {
  value = data.aws_region.current.id
}
# Este bloco de saída define uma saída chamada "aws_region". 
# Ele obtém o valor do ID da região AWS atual a partir da fonte de dados 'aws_region'.
# Isso permite que essa informação seja usada ou referenciada em outro lugar na configuração Terraform ou exibida após a execução do plano.

output "aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}
# Este bloco de saída define uma saída chamada "aws_caller_identity". 
# Ele obtém o valor do ID da conta AWS do chamador atual a partir da fonte de dados 'aws_caller_identity'.
# Isso é útil para exibir ou utilizar a identificação da conta AWS que está executando os recursos Terraform.

output "source_account_number" {
  value = local.source_account_number
}
# Este bloco de saída define uma saída chamada "source_account_number". 
# Ele obtém o valor da variável local 'source_account_number'.
# Isso permite que o número da conta fonte, previamente definido em uma variável local, seja referenciado ou exibido após a execução do plano.
