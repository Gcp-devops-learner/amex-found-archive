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

variable friendly_name {}
variable "labels" { type = map(string) }
variable "location" {
  type    = string
  default = "US"
}

variable "id" { type = string }

variable "dataset_options" {
  type = object({
    default_table_expiration_ms     = number
    default_partition_expiration_ms = number
    delete_contents_on_destroy      = bool
  })
  default = {
    default_table_expiration_ms     = null
    default_partition_expiration_ms = null
    delete_contents_on_destroy      = false
  }
}

variable "project_id" { type = string }

variable "tables" {
  description = "Table definitions"
  type = map(object({
    friendly_name = string
    labels        = map(string)
    options = object({
      clustering      = list(string)
      encryption_key  = string
      expiration_time = number
    })
    partitioning = object({
      field = string
      range = object({
        end      = number
        interval = number
        start    = number
      })
      time = object({
        expiration_ms = number
        type          = string
      })
    })
    schema = string
  }))
  default = {}
}

variable "views" {
  description = "View definitions"
  type = map(object({
    friendly_name  = string
    labels         = map(string)
    query          = string
    use_legacy_sql = bool
  }))
  default = {}
}
