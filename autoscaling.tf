resource "aws_launch_configuration" "launch_webserver_ami" {
  name            = "webserver_as"
  image_id        = "ami-027fdb855d2c0ea38"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.sg_webserver1.id}"]
  key_name        = "sree"
  iam_instance_profile  = "ec2_s3"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "as_webserver" {
  name                 = "webserve_asg"
  launch_configuration = "${aws_launch_configuration.launch_webserver_ami.name}"
  availability_zones   = ["${var.az_list}"]
  min_size             = 2
  max_size             = 2
  target_group_arns    = ["${aws_lb_target_group.webserver_target.arn}"]
  vpc_zone_identifier  = ["${aws_subnet.public.*.id}"]

  lifecycle {
    create_before_destroy = true
  }
  tags = [
    {
      key                 = "Name"
      value               = "tomcat_webserver"
      propagate_at_launch = true
    } ]
}
