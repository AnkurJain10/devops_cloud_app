

# Web Application, Nginx and OpenVPN with Terraform and Ansible on AWS

Repository to deploy a Web Application, Nginx and a private VPN with OpenVPN and dnsmasq running on an EC2 instance in a private cloud on AWS. Bootstrapped with Terraform and Ansible.


## Prerequisites
### 1) Install AWS CLI and have it configured

### 2) Create a ssh key-pair to access the EC2 instance

```bash 
ssh-keygen -t rsa -C "your.email@example.com" -b 4096 -f ~/app_key -N ""`
chmod 400 ~/app_key
```

## Configuration
### 1) Create a file */terraform/terraform.tfvars*
```bash
aws_region    = "us-east-1" # Your AWS Region
aws_profile   = "terraform-app" # Your AWS Profile name (from step 2)
vpc_cidr      = "172.30.0.0/16" # Your private cloud CIDR
vpc_name      = "app network" # Name of your VPC
cidrs     = {
  public  = "172.30.3.0/24" # The public subnet CIDR
  private = "172.30.1.0/24" # The private subnet CIDR
}

app_public_key_path   = "~/app_key.pub" # Path to your local ssh key pair (from step 3)
app_private_key_path   = "~/app_key" # Path to your local ssh key pair (from step 3)
app_user = "ubuntu"
app_python_interpreter = "/usr/bin/python3"
aws_app_instance_type = "t2.micro"
aws_app_ami     = "ami-059eeca93cf09eebd"
ovpn_port      = "1194" # The OpenVPN port
```

### 2) Create a file */ansible/playbooks/roles/openvpn/default/main.yml*
```yml
ovpn_cidr: 10.3.0.0/24
ovpn_network: 10.3.0.0 255.255.255.0
ovpn_push_routes :
  - 172.30.0.0 255.255.0.0

ca_dir: /home/ubuntu/ca

ca_key_country: US
ca_key_province: Maryland
ca_key_city: Rockville
ca_key_org: MyOrganization
ca_key_email: your.email@organization.org
ca_key_org_unit: MyOrganizationUnit
ca_key_name: vpn_server
```
## Setup

### 1) Add the AWS credentials to your environment
```bash
export AWS_ACCESS_KEY_ID="YOUR_AWS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET"
export AWS_DEFAULT_REGION="YOUR_AWS_REGION"
```

### 2) Bootstrap the infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply

# This will create the following configuration files for ansible :
#           ./ansible/ansible_inventory 
#           ./ansible/playbooks/group_vars/vpn_public.yml
```

### 3) Install Nginx and monitoring script on the EC2 Instance
```bash
cd ansible

# This will install Nginx server and the Monitoring scripts in cron job
ansible-playbook -i ansible_inventory playbooks/server-setup-nginx.yml
```

### 4) Install OpenVPN on the EC2 Instance
```bash
cd ansible

# This will also add a client
ansible-playbook -i ansible_inventory playbooks/openvpn_install.yml -e username=ankurjain -e output=/tmp/ankur.zip
```

### 5) Add a client to the VPN
This will download the necessary OpenVPN config and credentails as a zip file to your host's home folder. See the output from Ansible.
```bash
cd ansible
ansible-playbook -i ansible_inventory playbooks/openvpn_add_client.yml -e username=ankurjain -e output=/tmp/ankur.zip
```

## TODO:
1) Use Docker containers for Nginx
2) Create Web App using Flask to accept Name, Email and Occupation and store it in a DB.
3) Containerize the App and DB
3) Enable SSL on Nginx
4) Deploy the code using Ansible



Thanks to Marblecodes for getting me on the right track with VPN via Ansible (https://github.com/marblecodes/openvpn-aws-tf-ansible)
