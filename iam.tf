resource "aws_iam_user" "grafana_reader" {
  name = "grafana-cloudwatch-reader"
}

resource "aws_iam_access_key" "grafana_key" {
  user = aws_iam_user.grafana_reader.name
}

resource "aws_iam_user_policy" "cloudwatch_read" {
  name = "CloudWatchLogsReadOnly"
  user = aws_iam_user.grafana_reader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:DescribeLogGroups",
          "logs:GetLogEvents",
          "logs:StartQuery",
          "logs:GetQueryResults"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

output "grafana_access_key" {
  value     = aws_iam_access_key.grafana_key.id
  sensitive = true
}

output "grafana_secret_key" {
  value     = aws_iam_access_key.grafana_key.secret
  sensitive = true
}