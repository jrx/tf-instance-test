provider "aws" {
  region = var.AWS_REGION
}

resource "aws_security_group" "allow_http" {
  name   = "${var.NAME}_allow_http"
  vpc_id = var.VPC_ID

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
    cidr_blocks = ["172.31.0.0/16"]
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
  instance_type          = "t3.micro"
  key_name               = var.KEY_NAME
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  count                  = 1

  tags = {
    Name  = "${var.NAME}-${count.index}"
    Owner = var.OWNER
    # Keep = ""
  }
}

resource "null_resource" "ansible" {
  count = 1

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.INSTANCE_USERNAME}/ansible",
      "sudo yum -y install epel-release",
      "sudo yum -y install ansible",
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