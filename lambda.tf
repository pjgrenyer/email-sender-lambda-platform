resource "aws_s3_object" "email_sender_lambda" {
  bucket = aws_s3_bucket.email_sender_lambda.id
  key    = "email-sender-lambda.zip"
  source = "lambdas/email-sender-lambda.zip"
}

resource "aws_lambda_function" "email_sender_lambda" {
  s3_bucket     = aws_s3_bucket.email_sender_lambda.id
  s3_key        = aws_s3_object.email_sender_lambda.key
  function_name = "email-sender-lambda"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  publish       = true

  runtime = "nodejs16.x"
  layers  = []
}

