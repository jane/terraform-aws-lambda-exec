# ---------------------------------------------------------------------------------------------------------------------
# EXECUTE A LAMBDA IN AWS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">=0.12"
}

resource "aws_cloudformation_stack" "execute_lambda" {
  amount             = var.amount
  name               = var.name
  tags               = var.tags
  timeout_in_minutes = var.timeout_in_minutes

  template_body = <<EOF
{
  "Description" : "Execute a Lambda and return the results",
  "Resources": {
    "${var.custom_name}": {
      "Type": "${join("", ["Custom", "::", var.custom_name])}",
      "Properties":
        ${jsonencode(
  merge(
    {
      "ServiceToken" = var.lambda_function_arn
    },
    var.lambda_inputs,
  ),
  )}
    }
  },
  "Outputs": {
    ${join(
  ",",
  formatlist(
    "\"%s\":{\"Value\": {\"Fn::GetAtt\":[\"%s\", \"%s\"]}}",
    var.lambda_outputs,
    var.custom_name,
    var.lambda_outputs,
  ),
)}
  }
}
EOF

}

