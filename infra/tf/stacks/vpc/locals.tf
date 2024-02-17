locals {
  default_tags = {
    Application = "Example"
    Stack       = "vpc"
    SCM_Org     = split("/", var.repository)[0]
    SCM_Repo    = split("/", var.repository)[1]
  }

  app_name       = local.default_tags["Application"]
  app_name_lower = lower(local.app_name)
}
