locals {
  default_tags = {
    Application = "Example"
    Stack       = "oidc"
    SCM_Org     = split("/", var.repository)[0]
    SCM_Repo    = split("/", var.repository)[1]
  }

  app_name       = local.default_tags["Application"]
  app_name_lower = lower(local.app_name)

  github_actions_role_name = "GithubActionsRole"
  github_role_readonly     = "${local.github_actions_role_name}-ReadOnly"
  github_role_write        = "${local.github_actions_role_name}-Write"
  state_backend_name       = "cball-${local.app_name_lower}-tf-backend-${var.environment}"
}
