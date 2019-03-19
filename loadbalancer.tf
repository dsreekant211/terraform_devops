
resource "aws_lb_target_group" "webserver_target" {
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.dev.id}"
  target_type = "instance"
#   path         = "/"
}

resource "aws_lb" "test" {
  name                       = "test-lb-tf"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = ["${aws_security_group.sg_webserver1.id}"]
  enable_deletion_protection = false
  subnets                    = ["${aws_subnet.public.*.id}"]
  #subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  tags = {
    Environment = "production"
  }
 }
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.test.arn}"
  port              = "8080"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.webserver_target.arn}"
  }
}
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = "${aws_lb_target_group.webserver_target.arn}"
  target_id        = "${aws_instance.webserver1.id}"
  port             = 8080
}
