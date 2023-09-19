resource "aws_lambda_function" "made_db_public" {
    filename = "lambda/make_db_public.zip"
    role = var.sbtphapp_lambda_role_arn
    function_name = "made_db_public_function"
    handler = "make_db_public.lambda_handler"

    runtime =  "python3.9"

    timeout = 30


}

resource "aws_lambda_invocation" "made_db_public_invoke" {
  function_name = aws_lambda_function.made_db_public.function_name

  input = jsonencode({
   VPCID = var.vpc_id
   DBSUBNETID =  var.database_subnet_id
   PUBLICRTID =  var.sbtphapp_public_rt_id
  })
}

output "made_db_public_invoke_result" {
  value = aws_lambda_invocation.made_db_public_invoke
}