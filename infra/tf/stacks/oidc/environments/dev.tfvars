environment = "dev"

github_refs_write = [
  # This will be used to restrict the permissions to only allow requests
  # from the listed branches or environments in GH Actions
  # In dev, we are allowing requests from all branches and environments
  # in order to permit provisioning of feature stack environments
  "repo:chrisba11/terraform-feature-stacks:*",
]
