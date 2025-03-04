locals {
  display_name = "Uptime check for ${var.uptime_monitoring_host}${var.uptime_monitoring_path == "/" ? "" : var.uptime_monitoring_path}"
}

resource "google_monitoring_uptime_check_config" "https" {
  project      = var.gcp_project
  display_name = local.display_name
  timeout      = var.uptime_check_timeout

  http_check {
    path         = var.uptime_monitoring_path
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project
      host       = var.uptime_monitoring_host
    }
  }

  selected_regions = ["usa-iowa", "usa-oregon", "usa-virginia"]
  period           = var.uptime_check_period

}