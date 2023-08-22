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

/******************************************
  Project for SCC Notifications
*****************************************/

module "scc_notifications" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 8.0"
  random_project_id = "true"
  //  impersonate_service_account = var.terraform_service_account
  default_service_account = "depriviledge"
  name                    = "prj-c-scc"
  org_id                  = var.org_id
  billing_account         = var.billing_account
  //folder_id                   = google_folder.common.id
  folder_id            = var.parent_folder
  activate_apis        = ["logging.googleapis.com", "pubsub.googleapis.com", "securitycenter.googleapis.com", "billingbudgets.googleapis.com"]
  skip_gcloud_download = var.skip_gcloud_download

  labels = {
    environment       = "production"
    application_name  = "org-scc"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "abcd"
    env_code          = "p"
  }
  //budget_alert_pubsub_topic   = var.scc_notifications_project_alert_pubsub_topic
  //budget_alert_spent_percents = var.scc_notifications_project_alert_spent_percents
  //budget_amount               = var.scc_notifications_project_budget_amount
}

