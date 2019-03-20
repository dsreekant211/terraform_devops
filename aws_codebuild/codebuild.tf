provider "aws" {
  region = "us-east-1"
}

// resource "aws_s3_bucket" "terbuild" {
//   bucket = "terbuild"
//   acl    = "private"
//   region = "us-west-1"
// }


resource "aws_iam_role" "codebuild_servicerole" {
  name = "codebuild_servicerole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
// resource "aws_iam_role_policy_attachment" "test-attach" {
//   role       = "${aws_iam_role.codebuild_servicerole.name}"
//   policy_arn = "${aws_iam_role_policy.code_build_policy.arn}"
// }


resource "aws_iam_role_policy" "code_build_policy" {
  role = "${aws_iam_role.codebuild_servicerole.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::sreekanthreddy",
        "arn:aws:s3:::sreekanthreddy/*"
      ]
    }
  ]
}
POLICY
}
resource "aws_codebuild_project" "tomcat" {
  name          = "tomcat-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild_servicerole.arn}"


  artifacts {
    type = "S3"
    location = "sreekanthreddy"
    packaging = "ZIP"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/java:openjdk-9"
    type         = "LINUX_CONTAINER"
  }
   source {
    type            = "GITHUB"
    location        = "https://github.com/dsreekant211/maven-project.git"
    git_clone_depth = 1
  }
}
resource "aws_codebuild_webhook" "github_webhook" {
  project_name = "${aws_codebuild_project.tomcat.name}"
}
  

