data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid = "Enable IAM User Permission"
    actions = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = [var.root_user]
    }
  }

  statement {
    sid = "Allow access for key administrator"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/key-master"
      ]
    }
  }
}

data "aws_iam_policy_document" "vpce_policy" {
  statement {
    actions = ["*"]
    effect     = "Allow"
    resources  = ["*"]
    
    # only allow access to the kms vpce by the keymaster and root users.
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/key-master",
        var.root_user
      ]
    }
  }
}

data "aws_iam_policy_document" "key_role_policy" {
  statement {
    actions = [
      "kms:DisableKey",
      "kms:ListAliases",
      "kms:ListKeyPolicies",
      "kms:ListKeys",
      "kms:ListResourceTags",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:GetParametersForImport",
      "kms:GetPublicKey",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:CancelKeyDeletion",
      "kms:CreateAlias",
      "kms:CreateKey",
      "kms:DeleteAlias",
      "kms:DeleteImportedKeyMaterial",
      "kms:DisableKey",
      "kms:DisableKeyRotation",
      "kms:EnableKey",
      "kms:EnableKeyRotation",
      "kms:ImportKeyMaterial",
      "kms:ScheduleKeyDeletion",
      "kms:UpdateAlias",
      "kms:UpdateKeyDescription",
      "kms:PutKeyPolicy",
      "iam:ListGroups",
      "iam:ListRoles",
      "iam:ListUsers",
      "logs:DescribeLogGroups",
      "logs:FilterLogEvents"
    ]
    effect     = "Allow"
    resources  = ["*"]
  }

  statement {
    actions = ["kms:*"]
    effect  = "Deny"
    resources = [resource.aws_kms_key.example.arn]
    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpce"
      values   = [resource.aws_vpc_endpoint.kms.arn]
    }
  }
}
