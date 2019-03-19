resource "aws_iam_instance_profile" "code_deploy" {
  name = "code_deploy_tomcat"
  role = "${aws_iam_role.codedeploy_role_tomcat.name}"
}


resource "aws_iam_role" "codedeploy_role_tomcat" {
  name = "codedeploy_role_tomcat"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "codedeploy.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
//   users      = ["${aws_iam_user.user.name}"]
  roles      = ["${aws_iam_role.codedeploy_role_tomcat.name}"]
//   groups     = ["${aws_iam_group.group.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
###############################################################################################
resource "aws_iam_instance_profile" "ec2_s3_codedeploy" {
  name = "ec2_s3_codedeploy"
  role = "${aws_iam_role.ec2-s3-codedeploy.name}"
}
resource "aws_iam_role" "ec2-s3-codedeploy" {
  name = "ec2-s3-codedeploy"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
resource "aws_iam_policy" "ec2_codedeploy_policy" {
  name        = "ec2_codedeploy_policy"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_policy_attachment" "ec2-s3-codedeploy" {
  name       = "ec2-s3-codedeploy"
//   users      = ["${aws_iam_user.user.name}"]
  roles      = ["${aws_iam_role.ec2-s3-codedeploy.name}"]
//   groups     = ["${aws_iam_group.group.name}"]
  policy_arn = "${aws_iam_policy.ec2_codedeploy_policy.arn}"
}
##################################################################
resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = "${aws_iam_role.codepipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
         "arn:aws:s3:::sreekanthreddy",
        "arn:aws:s3:::sreekanthreddy/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
