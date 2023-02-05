resource "aws_lb" "alb" {
    name = var.alb.name
    internal = false
    load_balancer_type = var.alb.load_balancer_type
    security_groups = [aws_security_group.alb_sg.id]
    subnets = [aws_subnet.public_subnets[var.public_subnets.public-subnet-01.key].id, aws_subnet.public_subnets[var.public_subnets.public-subnet-02.key].id]

    enable_deletion_protection = false
    
    depends_on = [
        aws_security_group.alb_sg
    ]
    tags = {
        Name = "terraform-alb"
    }
}

resource "aws_lb_target_group" "alb_target_group" {
    name = var.alb_target_group.name
    port = var.alb_target_group.port
    protocol = var.alb_target_group.protocol
    vpc-id = aws_vpc.vpc.id
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment_1" {
    for_each = var.instance_az1
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    target_id = aws_instance.instance-1-2[each.key].id
    port = var.alb_target_group.port
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment_2" {
    for_each = var.instance_az2
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    target_id = aws_instance.instance-3[each.key].id
    port = var.alb_target_group.port
}