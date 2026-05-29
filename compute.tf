resource "aws_launch_template" "app_template" {

  name_prefix = "shopease-app-"

  image_id = "ami-0c02fb55956c7d316"

  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  iam_instance_profile {

    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash

yum update -y

yum install -y httpd

systemctl start httpd

systemctl enable httpd

echo "ShopEase Application Server" > /var/www/html/index.html

EOF
)

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "ShopEase-App"
    }
  }
}

#ASG
resource "aws_autoscaling_group" "app_asg" {

  name = "ShopEase-ASG"

  desired_capacity = 2

  min_size = 2

  max_size = 4

  vpc_zone_identifier = [

    aws_subnet.private_app_subnet_1.id,

    aws_subnet.private_app_subnet_2.id
  ]

  launch_template {

    id = aws_launch_template.app_template.id

    version = "$Latest"
  }

  tag {

    key = "Name"

    value = "ShopEase-App"

    propagate_at_launch = true
  }

  target_group_arns = [
  aws_lb_target_group.app_tg.arn
]
}

resource "aws_lb_target_group" "app_tg" {

  name = "ShopEase-TG"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.shopease_vpc.id

  health_check {

    path = "/"

    protocol = "HTTP"

    healthy_threshold = 2

    unhealthy_threshold = 2

    timeout = 5

    interval = 30
  }
}

#Application Load Balancer
resource "aws_lb" "app_alb" {

  name = "ShopEase-ALB"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  tags = {
    Name = "ShopEase-ALB"
  }
}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.app_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
