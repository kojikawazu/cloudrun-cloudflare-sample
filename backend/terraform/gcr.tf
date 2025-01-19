# ---------------------------------------------
# Artifact Registry
# ---------------------------------------------
# Artifact Registryリポジトリの作成
resource "google_artifact_registry_repository" "hono_repo" {
  location      = var.gcp_region
  repository_id = var.repository_id
  description   = "Docker repository for Hono application"
  format        = "DOCKER"
}
