resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile { name = aws_iam_instance_profile.ec2_profile.name }
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>${var.project_name} is Live!</h1>" > /usr/share/nginx/html/index.html
  EOF
  )
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.project_name}-asg"
  desired_capacity           = 2
  max_size                  = 3
  min_size                  = 1
  vpc_zone_identifier       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.app_tg.arn]
  health_check_type = "EC2"
}
