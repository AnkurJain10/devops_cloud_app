variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "keys/app.pub"
}

variable "AMIS_AWS_LINUX" {
  type = "map"
  default = {
    us-east-1 = "ami-97785bed"
  }
}

variable "AMIS_UBUNTU" {
  type = "map"
  default = {
    us-east-1 = "ami-5c150e23"
  }
}

