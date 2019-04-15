# ---------------------------------------------------------------------------------------------------------------------
# EXECUTE A LAMBDA IN AWS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">=0.9.2"
}

resource "aws_cloudformation_stack" "execute_lambda" {
  depends_on         = "${var.depends_on}"
  count              = "${var.count}"
  name               = "${var.name}"
  tags               = "${var.tags}"
  timeout_in_minutes = "${var.timeout_in_minutes}"

  template_body = <<EOF
{
  "Description" : "Execute a Lambda and return the results",
  "Resources": {
    "${var.custom_name}": {
      "Type": "${join("", list("Custom", "::", var.custom_name))}",
      "Properties":
        ${jsonencode(merge(map("ServiceToken",var.lambda_function_arn), var.lambda_inputs))}
    }
  },
  "Outputs": {
    ${join(",", formatlist("\"%s\":{\"Value\": {\"Fn::GetAtt\":[\"%s\", \"%s\"]}}", var.lambda_outputs, var.custom_name,var.lambda_outputs))}
  }
}
EOF
}
