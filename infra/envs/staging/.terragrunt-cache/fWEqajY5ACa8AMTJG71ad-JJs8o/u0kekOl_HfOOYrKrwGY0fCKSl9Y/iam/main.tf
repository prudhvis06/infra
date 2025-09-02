resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = var.assume_role_service
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = var.name
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  policy      = jsonencode(var.policy_document)
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
