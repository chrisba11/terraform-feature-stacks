environment = "prod"

github_refs_write = [
  # This will be used to restrict the permissions to only allow requests
  # from the listed branches or environments in GH Actions
  "repo:chrisba11/terraform-feature-stacks:ref:refs/heads/main",
  "repo:chrisba11/terraform-feature-stacks:environment:prod",
]
