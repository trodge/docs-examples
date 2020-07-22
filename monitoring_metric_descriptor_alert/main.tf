resource "google_monitoring_metric_descriptor" "with_alert" {
  description = "Daily sales records from all branch stores."
  display_name = "Daily sales"
  type = "custom.googleapis.com/stores/daily_sales"
  metric_kind = "GAUGE"
  value_type = "DOUBLE"
  unit = "{USD}"
}

resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "Alert on daily sales"
  combiner     = "OR"
  conditions {
    display_name = "test condition"
    condition_threshold {
      filter     = "metric.type=\"${google_monitoring_metric_descriptor.with_alert.type}\" AND resource.type=\"gce_instance\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
    }
  }
}