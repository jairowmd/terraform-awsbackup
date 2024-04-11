# arquivo de teste para mostrar variaveis e requests na tela antes do apply
# estou usando com o data

output "aws_region" {
   value = data.aws_region.current.id
 }


 output "aws_caller_identity" {
   value = data.aws_caller_identity.current.account_id
 }


