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
  instance_type          = "t2.micro"
  key_name               = var.KEY_NAME
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = var.PRIVATE_KEY
  }

  tags = {
    Name  = var.NAME
    Owner = var.OWNER
    # Keep = ""
  }
}

terraform {
  required_version = ">= 0.12"
}
