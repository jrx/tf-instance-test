variable "NAME" {
}

variable "OWNER" {
}

variable "VPC_ID" {
}

variable "KEY_NAME" {
}

variable "PRIVATE_KEY" {
}

variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    eu-central-1 = "ami-337be65c" # centos 7
  }
}

variable "INSTANCE_USERNAME" {
  default = "centos"
}
