/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "scc" {
  source = "../../../modules/security_command_center"

  parent_folder                                  = google_folder.common.id
  scc_notifications_project_budget_amount        = 1000
  scc_notifications_project_alert_spent_percents = [0.5, 0.75, 0.9, 0.95]
  scc_notifications_project_alert_pubsub_topic   = "scc_notifications"
  scc_notification_name                          = "scc_notification"

  billing_account           = local.org.billing_account
  org_id                    = local.org.org_id
  terraform_service_account = local.org.terraform_service_account
}

module "log_sink" {
  source = "../../../modules/log_sinks"

  org_id          = local.org.org_id
  billing_account = local.org.billing_account

  parent_folder                  = google_folder.common.id
  terraform_service_account      = local.org.terraform_service_account
  audit_logs_table_expiration_ms = 2592000000 // 30 days

  //org_billing_logs_project_alert_spent_percents = [0.5, 0.75, 0.9, 0.95]
  //org_billing_logs_project_budget_amount = 1000
  org_billing_logs_project_alert_pubsub_topic = "billing_log"

  //org_audit_logs_project_alert_spent_percents = [0.5, 0.75, 0.9, 0.95]
  //org_audit_logs_project_budget_amount = 1000
  org_audit_logs_project_alert_pubsub_topic = "audit_log"

  audit_data_users   = "admin@camilojimenezcft.joonix.net"
  billing_data_users = "admin@camilojimenezcft.joonix.net"

  default_region = "us-east1"
}
