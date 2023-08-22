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

locals {
  vpc_name                = "${var.environment_code}-shared-base"
  network_name            = "vpc-${local.vpc_name}"
  private_googleapis_cidr = "199.36.153.8/30"
}

module "shared_vpc_host_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 8.0"

  billing_account   = var.billing_account
  org_id            = var.org_id
  folder_id         = var.folder_id
  name              = "prj-${var.environment_code}-shared-base" // restricted
  random_project_id = "true"

  impersonate_service_account = var.terraform_service_account
  skip_gcloud_download        = var.skip_gcloud_download
  disable_services_on_destroy = false

  activate_apis = [
    // "accesscontextmanager.googleapis.com", //restricted
    // "cloudresourcemanager.googleapis.com", //restricted

    "billingbudgets.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "logging.googleapis.com",
    "servicenetworking.googleapis.com",
  ]

  labels = {
    application_name  = "base-shared-vpc-host" //restricted
    billing_code      = "1234"
    business_code     = "abcd"
    env_code          = var.environment_code
    primary_contact   = "example1"
    secondary_contact = "example2"
  }
}



module "shared_vpc_network" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 2.0"
  project_id                             = module.shared_vpc_host_project.project_id
  network_name                           = local.network_name
  shared_vpc_host                        = "true"
  delete_default_internet_gateway_routes = "true"

  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

  routes = [{
    name              = "rt-${local.vpc_name}-1000-all-default-private-api"
    description       = "Route through IGW to allow private google api access."
    destination_range = "199.36.153.8/30"
    next_hop_internet = "true"
    priority          = "1000"
    },
    {
      name              = "rt-${local.vpc_name}-1000-egress-internet-default"
      description       = "Tag based route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-internet"
      next_hop_internet = "true"
      priority          = "1000"
    }
  ]
}

