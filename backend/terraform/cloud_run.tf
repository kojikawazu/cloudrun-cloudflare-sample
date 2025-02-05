# ---------------------------------------------
# Cloud Run
# ---------------------------------------------
# Google Cloud Run のサービスアカウントを作成
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run Service Account"
}

# Google Cloud Run にデプロイするサービス
resource "google_cloud_run_service" "hono_service" {
  name     = var.service_name
  location = var.gcp_region

  metadata {
    namespace = var.gcp_project_id
  }

  template {
    spec {
      containers {
        image = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${google_artifact_registry_repository.hono_repo.repository_id}/${var.service_name}"

        ports {
          container_port = var.http_port
        }
        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }
      }
      service_account_name = google_service_account.cloud_run_sa.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.run,
    google_artifact_registry_repository.hono_repo
  ]
}

# Cloud Run API を有効化
resource "google_project_service" "run" {
  service = "run.googleapis.com"
  project = var.gcp_project_id
}

# カスタムドメインのマッピング
resource "google_cloud_run_domain_mapping" "custom_domain" {
  name     = var.custom_domain_name
  location = var.gcp_region

  metadata {
    namespace = var.gcp_project_id
  }

  spec {
    route_name = google_cloud_run_service.hono_service.name
  }

  depends_on = [
    google_cloud_run_service.hono_service
  ]
}
