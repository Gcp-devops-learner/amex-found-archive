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


resource "google_container_cluster" "cluster" {
  project  = var.project_id
  name     = var.name
  location = var.region
  network  = var.network

  // remove default node pool and create separately
  remove_default_node_pool = true
  initial_node_count       = 1
}


resource "google_container_node_pool" "node_pool" {
  name       = "node-pool"
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  // project

  node_config {
    preemptible  = true
    machine_type = var.machine_type
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

