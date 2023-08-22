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
  name            = "vm-shared"
  activate_apis   = []
  environment     = "e0"
  primary_contact = "person1"
  extra_labels    = { extra = "value" }
  shared_vpc      = local.env.host_project_id
}

// Sample resource
resource "google_compute_instance" "shared-vpc-vm" {
  project      = module.project.project_id
  name         = "shared-vpc-vm"
  machine_type = "n1-standard-1"
  description  = "Managed by Terraform"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = local.env.host_vpc_network
    subnetwork = local.env.host_vpc_subnets[0]
  }

  zone = "us-west1-a"
}