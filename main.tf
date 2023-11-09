provider "aws" {
  region = var.AWS_REGION
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    workspaces = {
      name = "net-dev"
    }
    hostname     = "app.terraform.io"
    organization = "jrx"
  }
}

resource "aws_security_group" "allow_http" {
  name   = "${var.NAME}_allow_http"
  vpc_id = data.terraform_remote_state.vpc.outputs.aws_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg-${var.NAME}"
    Owner = var.OWNER
  }
}

resource "aws_instance" "example" {
  ami                    = var.AMIS[var.AWS_REGION]
  instance_type          = "m5.large"
  key_name               = var.KEY_NAME
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  count                  = var.NUMBER

  availability_zone = data.terraform_remote_state.vpc.outputs.aws_azs[count.index % length(data.terraform_remote_state.vpc.outputs.aws_azs)]
  subnet_id         = data.terraform_remote_state.vpc.outputs.aws_public_subnets[count.index % length(data.terraform_remote_state.vpc.outputs.aws_azs)]

  tags = {
    Name  = "${var.NAME}-${count.index}"
    Owner = var.OWNER
    # Keep = ""
  }
}

resource "null_resource" "ansible" {
  count = var.NUMBER

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.INSTANCE_USERNAME}/ansible",
      "sudo yum -y install python3-pip",
      "sudo python3 -m pip install ansible --quiet",
    ]
  }

  provisioner "file" {
    source      = "./ansible/"
    destination = "/home/${var.INSTANCE_USERNAME}/ansible/"
  }
  provisioner "remote-exec" {
    inline = [
      "cd ansible; ansible-playbook -c local -i \"localhost,\" test.yml",
    ]
  }

  connection {
    host        = coalesce(element(aws_instance.example.*.public_ip, count.index), element(aws_instance.example.*.private_ip, count.index))
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = var.PRIVATE_KEY
  }

  triggers = {
    always_run = timestamp()
  }
}
