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
  folder_id       = local.env0.folder
  name            = "bq-example"
  activate_apis = [
    "bigquery.googleapis.com"
  ]
  environment     = "e0"
  primary_contact = "person1"
  extra_labels    = { extra = "value" }
}

module "bigquery" {
  source        = "../../../../modules/bigquery"
  project_id    = module.project.project_id
  id            = "sample_dataset"
  friendly_name = "Sample Dataset"
  tables = {
    sample_table = {
      friendly_name = "Sample Table"
      labels        = {}
      options       = null
      partitioning = {
        field = null
        range = null // use start/end/interval for range
        time  = { type = "DAY", expiration_ms = null }
      }
      schema = file("files/sample_table.json")
    }
  }
  views = {
    sample_view = {
      friendly_name  = "Sample View"
      labels         = {}
      query          = "SELECT * from `${module.project.project_id}.sample_dataset.sample_table`"
      use_legacy_sql = false
    }
  }
  labels = { tag1 = "value1" }
}
