variable "region" {
  default = "us-west-1a"
  description = "AWS Region"
}

variable "ami" {
  default = "ami-00831fc7c1e3ddc60"
  description = "Amazon Machine Image ID"
}

variable "type" {
  default = "t2.micro"
  description = "Size of VM"
}
