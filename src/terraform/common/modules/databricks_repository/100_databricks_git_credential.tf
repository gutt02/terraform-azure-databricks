# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/git_credential
resource "databricks_git_credential" "this" {
  git_username          = var.databricks_repository.databricks_git_credential.git_username
  git_provider          = var.databricks_repository.databricks_git_credential.git_provider
  personal_access_token = var.git_personal_access_token
}
