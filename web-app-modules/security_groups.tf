resource "aws_security_group" "instances" {
    name = var.instances_sg.name
    description = "Security group for my terraform instances"
    vpc_id = aws_vpc.Altschool_vpc.id

    dynamic "ingress" {
        for_each = var.instances_inbound_ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            security_groups = [aws_security_group.alb_sg.id]
        }
    }
    ingress {
        description = "inbound traffic for ssh"
        from_port = var.ec2_instance_ssh_port
        to_port = var.ec2_instance_ssh_port
        protocol = "tcp"
        cidr_blocks = var.ec2_instance_sg_ssh_cidr_block
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr-blcoks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "altschool-terraform-ec2-instance-sg"
    }
}

resource "aws_security_group" "alb_sg" {
    name = var.alb_sg.name
    description = var.alb_sg.description
    vpc_id = aws_vpc.Altschool_vpc.id

    dynamic "ingress" {
        for_each = var.alb_inbound_ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = var.alb_sg_cidr_block
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      Name = "altschool-terraform-alb-sg"
    }
}
