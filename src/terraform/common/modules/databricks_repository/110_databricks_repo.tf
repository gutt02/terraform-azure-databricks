# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/repo
resource "databricks_repo" "this" {
  url          = var.databricks_repository.databricks_repo.url
  git_provider = var.databricks_repository.databricks_repo.git_provider
  path         = var.databricks_repository.databricks_repo.path
  tag          = var.databricks_repository.databricks_repo.tag

  depends_on = [databricks_git_credential.this]
}
