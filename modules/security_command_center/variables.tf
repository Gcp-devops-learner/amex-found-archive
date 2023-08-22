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
variable scc_notifications_project_budget_amount {}
variable scc_notifications_project_alert_spent_percents {}
variable scc_notifications_project_alert_pubsub_topic {}
variable skip_gcloud_download {
  default = true
}
variable parent_folder {}
variable billing_account {}
variable org_id {}
variable scc_notification_name {}
variable scc_notification_filter {
  default = "state=\\\"ACTIVE\\\""
}
variable terraform_service_account {}
