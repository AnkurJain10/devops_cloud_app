resource "aws_key_pair" "app" {
  key_name = "app"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
  lifecycle {
    ignore_changes = ["public_key"]
  }
}