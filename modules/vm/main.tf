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


resource "google_compute_instance" "default" {
  project      = var.project_id
  name         = "vm-${var.name}"
  machine_type = var.instance_type
  description  = "Managed by Terraform"

  boot_disk {
    initialize_params {
      type  = var.boot_disk.type
      image = var.boot_disk.image
      size  = var.boot_disk.size_gb
    }
  }

  network_interface {
    network = var.nic.network
  }

  metadata = {
    startup-script = var.startup_script
  }

  zone = var.zone

}

