variable "databricks_repository" {
  type        = any
  description = "Databricks Git repository."
}

variable "git_personal_access_token" {
  type        = string
  sensitive   = true
  description = "Personal access token."
}
