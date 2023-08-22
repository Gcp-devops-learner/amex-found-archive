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
  name            = "vm-example"
  activate_apis   = []
  environment     = "e0"
  primary_contact = "person1"
  extra_labels    = { extra = "value" }
}


resource "google_compute_network" "default" {
  project                 = module.project.project_id
  name                    = "net1"
  auto_create_subnetworks = true
}


// air-gapped, no firewall rules
module "webserver" {
  source = "../../../../modules/vm"

  name          = "webserver"
  instance_type = "e2-standard-2"
  project_id    = module.project.project_id

  startup_script = "echo 1 > /tmp/started"

  nic = {
    network    = google_compute_network.default.id
    subnetwork = "net1"
  }

  zone = "us-central1-a"
}