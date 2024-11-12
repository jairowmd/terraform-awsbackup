
# O arquivo data.tf é utilizado para definir dados que serão utilizados no projeto Terraform. 
#Esses dados podem ser utilizados para configurar recursos, variáveis, etc.

# pegando dados via API da AWS
data "aws_caller_identity" "current" {}
# Esta linha utiliza a fonte de dados 'aws_caller_identity' para obter informações sobre a identidade do chamador atual,
# como o ID da conta AWS, o ID do usuário IAM e o ARN (Amazon Resource Name) do chamador atual.
# O resultado é armazenado na variável "current".

data "aws_region" "current" {}
# Esta linha utiliza a fonte de dados 'aws_region' para obter a região AWS configurada no provedor.
# O resultado é armazenado na variável "current".
