output "app-public-ip" {
	value = "${aws_instance.app.public_ip}"
}

output "app-private-ip" {
	value = "${aws_instance.app.private_ip}"
}

output "app-public-dns" {
	value = "${aws_instance.app.public_dns}"
}