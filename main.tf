provider "aws" {
  region     = "us-east-1"
 }

resource "aws_instance" "webserver1" {
  # count = "${length(var.pub_sub_cidr)}"
  ami                         = "ami-027fdb855d2c0ea38"
  instance_type               = "t2.micro"
  depends_on                  = ["aws_internet_gateway.gw"]
  availability_zone           = "${var.az_list[count.index]}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.sg_webserver1.id}"]
  key_name                    = "sree"
  subnet_id                   = "${element(aws_subnet.public.*.id, count.index)}"

  tags {
    Name = "image"
  }
}
resource "aws_security_group" "sg_webserver1" {
  name = "Allow http port"
  vpc_id      = "${aws_vpc.dev.id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 }
# resource "aws_ami_from_instance" "webserver1_ami" {
#   name               = "webserver1_ami"
#   source_instance_id = "${aws_instance.webserver1.id}"
#   snapshot_without_reboot = "false"
#   tags {
#     Name = "webserver1_ami"
#   }
# }







