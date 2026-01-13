variable "ANSIBLE_PLAYBOOK" {
  type    = string
  default = "test.yml"
}

variable "ANSIBLE_ROLE_ID" {
}

variable "ANSIBLE_SECRET_ID" {
}

variable "VAULT_ADDR" {
}

variable "VAULT_TOKEN" {
}

variable "VAULT_NAMESPACE" {
}

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
    #eu-north-1 = "ami-07c0f40b66e9893c4" # rocky linux 9
    eu-north-1 = "ami-0c4b8477135926c4f" # rhel 9
    #eu-north-1 = "ami-08526b399bb6eb2c7" # rhel 10
  }
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}
