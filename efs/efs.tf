// resource "aws_efs_file_system" "web" {
//   creation_token = "my-product"

//   tags = {
//     Name = "myweb"
//   }
// }
// resource "aws_efs_mount_target" "alpha" {
//   file_system_id = "${aws_efs_file_system.web.id}"
//   subnet_id      = "${aws_subnet.alpha.id}"
//   security_groups = ["${aws_security_group.sg_webserver.id}"]
// }
// output "efs_dns" {
//   value = "${aws_efs_file_system.web.dns_name}"
// }
// output "efs_id" {
//   value = "${aws_efs_file_system.web.id}"
// }
