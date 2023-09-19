resource "aws_iam_role" "sbtphapp_lambda_role" {
    name = "sbtphapp_lambda_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            },
        ]
    })

    inline_policy {
        name = "sbtphapp_inline_policy"

        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action = ["ec2:*"]
                    Effect = "Allow"
                    Resource = "*"
                }
            ]
        })
    }
  
}
resource "aws_iam_role" "sbtphapp_ec2_role" {
    name = "sbtphapp_ec2_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })

    inline_policy {
        name = "sbtphapp_instance_inline_policy"

        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action = ["ec2:Describe*"]
                    Effect = "Allow"
                    Resource = "*"
                }
            ]
        })
    }
  
}

resource "aws_iam_instance_profile" "ec2_instance_proile" {
  name = "ec2_instance_proile"
  role = aws_iam_role.sbtphapp_ec2_role.name
}

output "sbtphapp_lambda_role_arn" {
    value = aws_iam_role.sbtphapp_lambda_role.arn
}

output "sbtphapp_instance_profile_name"  {
    value = aws_iam_instance_profile.ec2_instance_proile.name
}
