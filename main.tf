locals {
  display_name = "Uptime check for ${var.uptime_monitoring_host}${var.uptime_monitoring_path == "/" ? "" : var.uptime_monitoring_path}"
}

resource "google_monitoring_uptime_check_config" "this" {
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

resource "google_monitoring_alert_policy" "failure_alert" {
  display_name = "Failure of uptime check for: ${local.display_name}"
  combiner     = "OR"

  conditions {
    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.this.uptime_check_id}\" AND resource.type=\"uptime_url\""
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      duration        = "60s"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = "1200s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = []
      }
    }
    display_name = "Failure of uptime check for: ${local.display_name}"
  }

  notification_channels = var.alert_notification_channels
  project               = var.gcp_project

  depends_on = [
    google_monitoring_uptime_check_config.this
  ]
}