resource "aws_instance" "app" {
  ami = "${lookup(var.AMIS_UBUNTU, var.AWS_REGION)}"
  instance_type = "t2.micro"
  # the VPC subnet

  subnet_id = "${aws_subnet.application-public-a1-sb.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh-sg.id}","${aws_security_group.app-sg.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.app.key_name}"
  
  tags {
      Name = "app"
      Owner = "Ankur"
  }
}