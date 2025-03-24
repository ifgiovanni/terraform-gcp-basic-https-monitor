variable "gcp_project" {
  type        = string
  description = "The Google Cloud project ID."
}

variable "uptime_check_period" {
  type        = string
  description = "The supported values are 60s, 300s, 600s, and 900s."
  default     = "60s"
}

variable "uptime_check_timeout" {
  type        = string
  description = "The maximum amount of time to wait for the request to complete (must be between 1 and 60 seconds)."
  default     = "10s"
}

variable "uptime_monitoring_host" {
  type        = string
  description = "A hostname to monitor"
}

variable "uptime_monitoring_path" {
  type        = string
  description = "The path to monitor on the host"
  default     = "/"
}

variable "alert_notification_channels" {
  type        = list(string)
  description = "A list of notification channels to notify when the uptime check fails."
  default     = []

}
