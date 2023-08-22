#!/usr/bin/env python
# Copyright 2020 Google LLC
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# usage:
# > terraform plan -o out.plan
# > terraform show -json out.plan | python validator.py

import json
import sys
import logging

logging.basicConfig(level=logging.INFO)

def validate_resource(r):
  """ look into the globals to find an appropriate validator
  """
  print(r)
  if not 'type' in r:
    return logging.error('no type detected')

  validator_name = "validate_" + r['type']
  validator = globals().get(validator_name, not_implemented)
  if validator(r):
    logging.info("validated [%s]" % r['address'])

def not_implemented(r):
  logging.warning('validator not implemented [%s]' % r['type'])
  logging.debug(r)

def get_all_resources(o):
  """ deeply traverse a state/plan to find all resources
  """
  if isinstance(o, list):
    for i in o:
      yield from get_all_resources(i)
  elif isinstance(o, dict):
    if 'resources' in o:
      yield from o['resources']
    else:
      yield from get_all_resources([ o[k] for k in o.keys() ])

def evaluate_plan(inp):
  """ evaluate a terraform plan for compliance
  """
  logging.info("terraform plan detected")
  planned_values = inp['planned_values']
  list(map(validate_resource, get_all_resources(planned_values)))

# --------- validators -----------------

def validate_google_project(p):
  """ validate a google_project resource
  """
  values = p['values']
  if not values['name'].startswith('prj'):
    logging.error("project name should start with 'prj-', [%s]" % values['name'])
  return True


def validate_google_service_account(sa):
  values = sa['values']
  if not values['description']:
    logging.error("service accounts should have a description")
  return True

if __name__ == "__main__":
  inp = json.load(sys.stdin)
  
  if 'planned_values' in inp:
    evaluate_plan(inp)
  else:
    evaluate_state(inp)

