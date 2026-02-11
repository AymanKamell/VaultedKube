
data "aws_iam_policy_document" "load_balancer_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "load_balancer_controller" {
  assume_role_policy = data.aws_iam_policy_document.load_balancer_controller_assume_role_policy.json
  name               = "${var.project_name}-aws-load-balancer-controller"
}

# The policy is quite large, so we typically download it or reference it. 
# For simplicity, we'll assume the user might need to download it or we can provide a simplified version / use a data source if the provider supports it.
# However, to avoid a huge file content here, let's use the recommended way: downloading the policy JSON or using a local file.
# Since we can't easily download in TF without an external provider, let's assume we fetch it via http provider or just put the policy content here.

# Ideally, we should use the http provider to fetch the policy.
# curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

resource "aws_iam_policy" "load_balancer_controller" {
  name        = "${var.project_name}-AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWS Load Balancer Controller IAM Policy"

  # We will use the file function to load the policy from a local file which we will create.
  policy = file("${path.module}/iam_policy.json") 
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller_attach" {
  role       = aws_iam_role.load_balancer_controller.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}

output "lbc_role_arn" {
  value = aws_iam_role.load_balancer_controller.arn
}
