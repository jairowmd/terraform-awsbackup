# pegando dados via api da aws
data "aws_caller_identity" "current" {}

data "aws_region" "current" {

}