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
resource "google_bigquery_dataset" "default" {
  dataset_id    = var.id
  friendly_name = var.friendly_name
  description   = "managed by terraform"
  location      = var.location

  project = var.project_id
  labels  = var.labels

  default_table_expiration_ms     = var.dataset_options.default_table_expiration_ms
  delete_contents_on_destroy      = var.dataset_options.delete_contents_on_destroy
  default_partition_expiration_ms = var.dataset_options.default_partition_expiration_ms
}
