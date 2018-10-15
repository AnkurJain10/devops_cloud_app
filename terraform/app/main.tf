######## --------------------- SECURITY GROUPS
resource "aws_security_group" "app_sg" {
  name   = "app DEFAULT SG"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "${var.ovpn_port}"
    to_port     = "${var.ovpn_port}"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

######## --------------------- KEY PAIR
resource "aws_key_pair" "app" {
  key_name   = "app"
  public_key = "${file(var.app_public_key_path)}"
  lifecycle {
    ignore_changes = ["public_key"]
  }
}

######## --------------------- app INSTANCE
resource "aws_instance" "app" {
  instance_type = "${var.aws_app_instance_type}"
  ami           = "${var.aws_app_ami}"

  tags {
      Name = "app"
      Owner = "Ankur"
  }

  key_name                    = "${aws_key_pair.app.id}"
  vpc_security_group_ids      = ["${aws_security_group.app_sg.id}"]
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = true
  source_dest_check           = false
}

######### ------------ Add NAT routing on private routing table
resource "aws_route" "NAT_routing" {
  route_table_id         = "${var.private_route_table}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${aws_instance.app.id}"
}
