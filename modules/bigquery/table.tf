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


resource "google_bigquery_table" "default" {
  for_each = var.tables

  provider      = google-beta
  project       = var.project_id
  table_id      = each.key
  friendly_name = each.value.friendly_name
  dataset_id    = google_bigquery_dataset.default.dataset_id
  description   = "managed by terraform"

  clustering      = try(each.value.options.clustering, null)
  expiration_time = try(each.value.options.expiration_time, null)
  labels          = each.value.labels
  schema          = each.value.schema


  dynamic range_partitioning {
    for_each = try(each.value.partitioning.range, null) != null ? [""] : []
    content {
      field = each.value.partitioning.field
      range {
        start    = each.value.partitioning.range.start
        end      = each.value.partitioning.range.end
        interval = each.value.partitioning.range.interval
      }
    }
  }

  dynamic time_partitioning {
    for_each = try(each.value.partitioning.time, null) != null ? [""] : []
    content {
      expiration_ms = each.value.partitioning.time.expiration_ms
      field         = each.value.partitioning.field
      type          = each.value.partitioning.time.type
    }
  }

  depends_on = [
    google_bigquery_dataset.default
  ]
}
