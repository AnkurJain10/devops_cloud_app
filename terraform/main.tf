variable "aws_region" {}
variable "aws_profile" {}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "app_private_key_path" {}
variable "app_user" {}
variable "app_python_interpreter" {}

variable "cidrs" {
  type = "map"
}
variable "app_public_key_path" {}
variable "aws_app_instance_type" {}
variable "aws_app_ami" {}
variable "ovpn_port" {}

provider "aws" { 
    region = "${var.aws_region}"
}

module "network" {
  source = "./network"

  aws_region  = "${var.aws_region}"
  aws_profile = "${var.aws_profile}"
  vpc_name    = "${var.vpc_name}"
  vpc_cidr    = "${var.vpc_cidr}"
  cidrs       = "${var.cidrs}"
}

module "app_instance" {
  source = "./app"

  vpc_id                = "${module.network.vpc_id}"
  subnet_id             = "${module.network.public_subnet_id}"
  private_route_table   = "${module.network.private_route_table}"
  vpc_cidr              = "${var.vpc_cidr}"
  app_public_key_path   = "${var.app_public_key_path}"
  aws_app_instance_type = "${var.aws_app_instance_type}"
  aws_app_ami           = "${var.aws_app_ami}"
  ovpn_port             = "${var.ovpn_port}"
}

resource "null_resource" "generate_inventory" {
  provisioner "local-exec" {
    command = <<EOD
    cat <<EOF > ../ansible/playbooks/group_vars/app_public.yml
aws_instance_id: ${module.app_instance.app_instance_id}
vpn_gateway: ${module.app_instance.private_ip}
ovpn_port: ${var.ovpn_port}
vpc_cidr: ${var.vpc_cidr}
EOF
EOD
  }

  provisioner "local-exec" {
    command = <<EOD
    cat <<EOF > ../ansible/ansible_inventory
aws_region=${var.aws_region}

[vpn_public]
${module.app_instance.public_ip}

[vpn_public:vars]
ansible_ssh_private_key_file=${var.app_private_key_path}
ansible_user=${var.app_user}
ansible_python_interpreter=${var.app_python_interpreter}

[vpn]
${module.app_instance.private_ip}

[vpn:vars]
ansible_ssh_private_key_file=${var.app_private_key_path}
ansible_user=${var.app_user}
ansible_python_interpreter=${var.app_python_interpreter}

EOF
EOD
  }
}
