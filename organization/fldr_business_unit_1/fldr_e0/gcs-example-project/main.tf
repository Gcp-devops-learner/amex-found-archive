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

module "project" {
  source          = "../../../../modules/project"
  billing_account = local.org.billing_account
  org_id          = local.org.org_id
  folder_id       = local.env.folder
  name            = "gcs-example"
  activate_apis = [
    "storage.googleapis.com"
  ]
  environment     = "e0"
  primary_contact = "person1"
  extra_labels    = { extra = "value" }
}

module "cloud-storage" {
  source = "../../../../modules/cloud-storage"

  project_id   = module.project.project_id
  project_name = module.project.project_name

  buckets = {
    bucket-11 = {
      storage_class = "MULTI_REGIONAL"
      versioning    = true
      extra_labels  = { extra1 = "value1" }
    },
    bucket-21 = {
      storage_class = "MULTI_REGIONAL"
      versioning    = false
      extra_labels  = { extra2 = "value2" }
    }
  }
}
