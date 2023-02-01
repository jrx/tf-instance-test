variable "NAME" {
}

variable "OWNER" {
}

variable "KEY_NAME" {
}

variable "PRIVATE_KEY" {
}

variable "NUMBER" {
}

variable "AWS_REGION" {
  default = "eu-north-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    #eu-central-1 = "ami-337be65c"          # centos 7
    #eu-north-1   = "ami-0358414bac2039369" # centos 7
    eu-north-1 = "ami-03ab37ade73ce076e" # rocky linux 8
  }
}

variable "INSTANCE_USERNAME" {
  default = "rocky"
}
