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

resource "google_storage_bucket" "buckets" {
  for_each = var.buckets

  name          = "${var.project_name}-${each.key}"
  storage_class = each.value.storage_class

  versioning {
    enabled = each.value.versioning
  }

  labels = merge({
    name     = each.key
    location = lower(var.location)
  }, try(each.value.extra_labels, {}))

  // common to all buckets
  location           = var.location
  force_destroy      = false
  bucket_policy_only = true
  project            = var.project_id
}
