resource "aws_codepipeline" "tomcat_pipeline" {
  name     = "tomcat_pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "sreekanth"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["test"]

      configuration  {
        Owner  = "dsreekant211"
        Repo   = "aws_devops"
        Branch = "master"
        OAuthToken = "5a11e251ef50cd6f0380315fb77b8263490998bf"
        PollForSourceChanges = "true"
      }
    }
  }
  stage {
    name = "Build"

    action {
      name            = "Source"
      category        = "Source"
      owner           = "ThirdParty"
      provider        = "GitHub"
      output_artifacts = ["test"]
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
      input_artifacts = ["test"]
      version         = "1"

      configuration  {
        ProjectName = "${aws_codedeploy_app.tomcat_webapp.name}"
      }
    }
  }
}