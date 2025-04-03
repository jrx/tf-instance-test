resource "aws_iam_instance_profile" "ansible" {
  name = "${var.NAME}-ansible-instance-profile"
  role = aws_iam_role.ansible.name
}

resource "aws_iam_role" "ansible" {
  name               = "${var.NAME}-ansible-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}