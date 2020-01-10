variable "NAME" {
}

variable "OWNER" {
}

variable "VPC_ID" {
}

variable "KEY_NAME" {
}

variable "PATH_TO_PRIVATE_KEY" {
}

variable "AWS_PROFILE" {
  default = "default"
}

variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1    = "ami-13be557e"
    us-west-2    = "ami-06b94666"
    eu-central-1 = "ami-09356619876445425" # Ubuntu 18.04
  }
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
