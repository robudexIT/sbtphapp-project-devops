resource "aws_lambda_function" "made_db_private" {
    filename = "lambda/makeprivate/make_db_private.zip"
    role = var.sbtphapp_lambda_role_arn
    function_name = "made_db_private_function"
    handler = "make_db_private.lambda_handler"

    runtime =  "python3.9"

    timeout = 30


}

output "function_name" {
  value = aws_lambda_function.made_db_private.function_name
}
resource "aws_lambda_invocation" "made_db_private_invoke" {
  function_name = aws_lambda_function.made_db_private.function_name

  input = jsonencode({
   VPCID = var.vpc_id
   DBSUBNETID =  var.database_subnet_id
  })
}

output "made_db_private_invoke_result" {
  value = aws_lambda_invocation.made_db_private_invoke
}