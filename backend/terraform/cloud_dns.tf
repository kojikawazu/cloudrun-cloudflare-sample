# Cloud DNS の管理ゾーンを作成
resource "google_dns_managed_zone" "domain_zone" {
  name        = var.domain_zone_name
  dns_name    = var.domain_zone_dns_name
  description = "Managed zone for ${var.domain_zone_dns_name}"
}

# Google Cloud Run ドメインマッピング (カスタムドメインm)
resource "google_cloud_run_domain_mapping" "custom_domain" {
  name     = var.custom_domain_name
  location = var.gcp_region

  metadata {
    namespace = var.gcp_project_id
  }

  spec {
    route_name       = google_cloud_run_service.hono_service.name
    certificate_mode = "AUTOMATIC"
  }

  depends_on = [
    google_cloud_run_service.hono_service
  ]
}


# Google Cloud Run ドメインマッピング (www サブドメイン)
resource "google_cloud_run_domain_mapping" "www_custom_domain" {
  name     = "www.${var.custom_domain_name}"
  location = var.gcp_region

  metadata {
    namespace = var.gcp_project_id
  }

  spec {
    route_name       = google_cloud_run_service.hono_service.name
    certificate_mode = "AUTOMATIC"
  }

  depends_on = [
    google_cloud_run_service.hono_service
  ]
}

# CNAME レコード (www サブドメイン)
resource "google_dns_record_set" "www_cname" {
  name         = "www.${var.domain_zone_dns_name}"
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.domain_zone.name
  rrdatas      = [google_cloud_run_domain_mapping.www_custom_domain.status[0].resource_records[0].rrdata]
}
