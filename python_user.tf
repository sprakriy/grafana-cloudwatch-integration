# 1. Create the IAM User for the Python App
resource "aws_iam_user" "python_log_producer" {
  name = "JobPortal_Log_Producer"
}

# 2. Create the Access Keys (Save these carefully!)
resource "aws_iam_access_key" "producer_keys" {
  user = aws_iam_user.python_log_producer.name
}

# 3. Define the "Write-Only" Policy
resource "aws_iam_user_policy" "log_writer_policy" {
  name = "CloudWatch_Put_Logs_Only"
  user = aws_iam_user.python_log_producer.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        # Restrict permissions ONLY to the JobPortal log group
        Resource = "arn:aws:logs:*:*:log-group:JobPortal_Logs:*"
      }
    ]
  })
}

# Output the keys so you can add them to your WSL Ubuntu environment
output "access_key_id" {
  value = aws_iam_access_key.producer_keys.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.producer_keys.secret
  sensitive = true
}