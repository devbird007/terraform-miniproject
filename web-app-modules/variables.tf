# General variables

variable "aws_region" {
    description = "Default region for the provider"
    type = string
    default = "us-east-1"
}

variable "vpc_cidr_block" {
    description = "Cidr block for newly created vpc"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnets" {
    description = "Public-facing subnets in the vpc"
    type = map(any)
    default = {
        "public-subnet-01" = {
            name = "public-subnet-01"
            availability_zone = "us-east-1a"
            cidr_block = "10.0.0.100/24"
            key = "01-public"
        },
        "public-subnet-02" = {
            name = "public-subnet-02"
            availability_zone = "us-east-1b"
            cidr_block = "10.0.0.200/24"
            key = "02-public"
        }
    }
}

variable "private_subnets" {
    description = "Private subnets inside the vpc"
    type = map(any)
    default = {
        "private-subnet-01" = {
            name = "private-subnet-01"
            availability_zone = "us-east-1a"
            cidr_block = "10.0.100.0/24"
            key = "01-private"
        },
        "02-private" = {
            name = "private-subnet-02"
            availability_zone = "us-east-1b"
            cidr_block = "10.0.200.0/24"
            key = "02-private"
        }
    }
}

variable "instances_sg" {
    description = "Security group for the instances"
    type = map(any)
    default = {
        name = "instances-security-group"
    }
}

variable "instances_inbound_ports" {
    type = list(number)
    default = [80, 443]
}

variable "instances_ssh_port" {
    type = number
    default = 22
}

variable "alb_sg" {
    type = map(any)
    default = {
        name = "alb_sg"
        description = "Security group for the load balancer"
    }
}

variable "ec2_instance_sg_ssh_cidr_block" {
    default = ["0.0.0.0/0"]
}

variable "alb_sg_cidr_block" {
    default = ["0.0.0.0/0"]
}

variable "alb_inbound_ports" {
    type = list(number)
    default = [80, 443]
}


variable "instance_ami" {
    type = string
    default = "ami-00874d747dde814fa"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "instance_az1" {
    type = map(any)
    default = {
        web-server-01 = {
            az = "us-east-1a"
            key = "web-server-01"
        }
        web-server-02 = {
            az = "us-east-1a"
            key = "web-server-02"
        }
    }
}

variable "instance_az2" {
    type = map(any)
    default = {
        web-server-03 = {
            az = "us-east-1b"
            key = "web-server-03"
        }
    }
}

variable "instance_key" {
    type = string
    default = "amazon_keys"
}

variable "host_inventory" {
    type = map(any)
    default = {
        filename = "../ansible/host-inventory"
    }
}

variable "remote_exec" {
    type = map(any)
    default = {
        ssh_user = "ubuntu"
        private_key_path = "/home/manny/.ssh/amazon_keys.pem"
    }
}

variable "alb" {
    type = map(any)
    default = {
        name = "altschool-terraform-lb"
        load_balancer_type = "application"
    }
}

variable "alb_target_group" {
    type = map(any)
    default = {
        name = "target-group"
        port = 80
        protocol = "HTTP"
    }
}

variable "alb_listener_1" {
    type = map(any)
    default = {
        port = "80"
        protocol = "HTTP"
        action_type = "redirect"
        status_code = "HTTP_301"
    }
}

variable "alb_listener_2" {
    type = map(any)
    default = {
        port = "443"
        protocol = "HTTPS"
        action_type = "forward"
        ssl_policy = "ELBSecurityPolicy-2016-08"
    }
}

variable "domain" {
  type = map(any)
  default = {
    domain    = "devbird.me"
    subdomain = "terraform-test.devbird.me"
    type      = "A"
  }
}

variable "cert" {
  type = map(any)
  default = {
    cert_1 = {
      domain            = "devbird.me"
      validation_method = "DNS"
    }

    cert_2 = {
      domain            = "terraform-test.devbird.me"
      validation_method = "DNS"
    }
  }
}


