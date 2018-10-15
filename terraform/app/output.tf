output "public_ip" {
  value = "${aws_instance.app.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.app.private_ip}"
}

output "app_instance_id" {
  value = "${aws_instance.app.id}"
}

output "app_sg_id" {
  value = "${aws_security_group.app_sg.id}"
}
