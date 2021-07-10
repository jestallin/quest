# use the default vpc provided subnet
variable "subnet-us-east-1b" {
  default = "subnet-19144446"
}

# use the default vpc
variable "vpc-us-east-1" {
  default = "vpc-83aecefe"
}

variable "cert-quest-jstallings-me" {
  default = "arn:aws:acm:us-east-1:415090045172:certificate/3a167ce4-2ed3-4cf9-8171-0b04147698cd"
}