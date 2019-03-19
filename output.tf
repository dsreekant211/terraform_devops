# output "instance_ip_webserver1" {
#   value = "${aws_instance.webserver1.public_ip}"
# }
# output "instance_id1" {
#   value = "${aws_instance.webserver1.id}"
# }
output "load_balancer_arn" {
  value = "${aws_lb.test.arn}"
}
output "lb_dns" {
  value = "${aws_lb.test.dns_name}"
}
