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
      output_artifacts = ["target"]
      version          = "1"
      // output_artifacts = ["test"]

      configuration  {
        Owner  = "dsreekant211"
        Repo   = "maven-project"
        Branch = "master"
        OAuthToken = "5ba3061cb13d842a3f198207ae0f2967f3010855"
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
      input_artifacts = ["target"]
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
      input_artifacts = ["target"]
      version         = "1"

      configuration  {
        ApplicationName = "${aws_codedeploy_app.tomcat_webapp.name}"
        DeploymentGroupName = "${aws_codedeploy_deployment_group.tomcat_webapp_gr.deployment_group_name}"
      }
    }
  }
}