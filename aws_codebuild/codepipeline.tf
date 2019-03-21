resource "aws_codepipeline" "tomcat_pipeline" {
  name     = "tomcat_pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "sreekanthreddy"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"

      output_artifacts = ["source"]
      version          = "1"
      // output_artifacts = ["test"]

      configuration  {
        Owner  = "dsreekant211"
        Repo   = "maven-project"
        Branch = "master"
        OAuthToken = "377f5814352c81c22d828412e5b8007e2002ec42"
        PollForSourceChanges = "true"
      }
    }
  }
  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      output_artifacts = ["build"]
      version         = "1"

      configuration  {
        ProjectName = "${aws_codebuild_project.tomcat.name}"
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build"]
      version         = "1"

      configuration  {
        ApplicationName = "${aws_codedeploy_app.tomcat_webapp.name}"
        DeploymentGroupName = "${aws_codedeploy_deployment_group.tomcat_webapp_gr.deployment_group_name}"
      }
    }
  }
}