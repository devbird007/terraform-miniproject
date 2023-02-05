resource "aws_instance" "instance-1-2" {
    for_each = var.instance_az1
    ami = var.instance_ami
    instance_type = var.instance_type
    key_name = var.instance_key
    subnet_id = aws_subnet.public_subnets[var.public_subnets.public-subnet-01.key].id
    vpc_security_group_ids = [aws_security_group.instances.id]
    availability_zone = each.value.az

    tags = {
        Name = each.key
    }
}

resource "aws_instance" "instance-3" {
    for_each = var.instance_az2
    ami = var.instance_ami
    instance_type = var.instance_type
    key_name = var.instance_key
    subnet_id = aws_subnet.public_subnets[var.public_subnets.public-subnet-02.key].id
    vpc_security_group_ids = [aws_security_group.instances.id]
    availability_zone = each.value.az

    tags = {
        Name = each.key
    }
}

resource "local_file" "host_inventory" {
    filename = var.host_inventory.filename
    content = "[web_servers]\n${aws_instance.instance-1-2[var.instance_az1.web-server-01.key].public_ip}\n${aws_instance.instance-1-2[var.instance_az1.web-server-02.key].public_ip}\n${aws_instance.instance-3[var.instance_az2.web-server-03.key].public_ip}\n\n[server_1]\n${aws_instance.instance-1-2[var.instance_az1.web-server-01.key].public_ip}\n\n[server_2]\n${aws_instance.instance-1-2[var.instance_az1.web-server-02.key].public_ip}\n\n[server_3]\n${aws_instance.instance-3[var.instance_az2.web-server-03.key].public_ip}"
}

resource "null_resource" "ansible-1-2" {
    for_each = var.instance_az1
    provisioner "remote-exec" {
        inline = ["echo 'SSH is ready'"]

        connection {
            type = "ssh"
            user = var.remote_exec.ssh_user
            private_key = file(var.remote_exec.private_key_path)
            host = aws_instance.instance-1-2[each.key].public_ip
        }
    }
}

resource "null_resource" "ansible-3" {
    for_each = var.instance_az2
    provisioner "remote-exec" {
        inline = ["echo 'SSH is ready'"]

        connection {
            type = "ssh"
            user = var.remote_exec.ssh_user
            private_key = file(var.remote_exec.private_key_path)
            host = aws_instance.instance-3[each.key].public_ip
        }
    }
}

