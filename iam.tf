resource "aws_iam_role" "lambda" {
  name = "lambda"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "lambda_role_logs_policy" {
  name   = "LambdaLogsPolicy"
  role   = aws_iam_role.lambda.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "*"
        }
    ]
  }
EOF
}

# Deployment

resource "aws_iam_user" "email_sender_lambda_deploy" {
  name          = "email-sender-lambda-deploy"
  force_destroy = true
}

resource "aws_iam_user_policy" "lambda_s3_deploy_policy" {
  name = "EmailSenderLambdaS3DeployPolicy"
  user = aws_iam_user.email_sender_lambda_deploy.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::email-sender-lambda/email-sender-lambda-code*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "lambda_function_deploy_policy" {
  name = "EmailSenderLambdaFunctionDeployPolicy"
  user = aws_iam_user.email_sender_lambda_deploy.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "lambda:UpdateFunctionCode",
            "Resource": "arn:aws:lambda:eu-west-2:100241228786:function:email-sender-lambda"
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "email_sender_lambda_deploy" {
  user    = aws_iam_user.email_sender_lambda_deploy.name
  pgp_key = var.pgp_key
}

output "secret" {
  value = aws_iam_access_key.email_sender_lambda_deploy.encrypted_secret
}

output "id" {
  value = aws_iam_access_key.email_sender_lambda_deploy.id
}