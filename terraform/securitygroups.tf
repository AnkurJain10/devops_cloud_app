resource "aws_security_group" "allow-ssh-sg" {
  vpc_id = "${aws_vpc.application.id}"
  name = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 
  tags {
      Name = "allow-ssh-sg"
      Owner = "Ankur"
  }
}


resource "aws_security_group" "app-sg" {
  vpc_id = "${aws_vpc.application.id}"
  name = "app-sg"
  description = "security group that allows ingress traffic for Application and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

tags {
    Name = "app-sg"
    Owner = "Ankur"
  }
}

