terraform {
  backend "s3" {
    bucket         = "altsch00l-terraform-assignment"
    key            = "backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "altschool-terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


module "ec2" {
  source = "../web-app-modules"
  host_inventory = {
    filename = "../ansible/host-inventory"
  }
}

resource "null_resource" "ansible" {

  provisioner "local-exec" {
    command = <<-EOT
              export ANSIBLE_CONFIG=../ansible/ansible.cfg
              ansible-playbook ../ansible/deploy.yml
    EOT
  }
  depends_on = [
    module.ec2
  ]
}
