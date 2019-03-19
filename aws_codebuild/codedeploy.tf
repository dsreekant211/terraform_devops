resource "aws_codedeploy_app" "tomcat_webapp" {
  name = "tomcat_webapp"
}


resource "aws_codedeploy_deployment_group" "tomcat_webapp_gr" {
  app_name              = "${aws_codedeploy_app.tomcat_webapp.name}"
  deployment_group_name = "tomcat_group"
  service_role_arn      = "${aws_iam_role.codedeploy_role.arn}"
  deployment_type       = "IN_PLACE"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "tomcat_webserver"
    }
  }
}