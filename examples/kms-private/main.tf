resource "aws_kms_key" "example" {
  description = "example-key"
  policy      = data.aws_iam_policy_document.kms_policy.json
  
  tags = {
    Name = var.project_name
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.project_name
  }
}

resource "aws_vpc_endpoint" "kms" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.kms"
  vpc_endpoint_type = "Interface"
  policy            = data.aws_iam_policy_document.vpce_policy.json
  
  tags = {
    Name = var.project_name
  }
}
resource "aws_iam_user_policy" "key-master" {
  name = "key-master-policy"
  user = aws_iam_user.keymaster.name

  policy = data.aws_iam_policy_document.key_role_policy.json
}

resource "aws_iam_user" "keymaster" {
  name = "key-master"

  tags = {
    Name = var.project_name
  }
}

resource "aws_iam_access_key" "keymaster" {
  user = aws_iam_user.keymaster.name
}

output "secret" {
  value = aws_iam_access_key.keymaster.secret
  sensitive = true
}