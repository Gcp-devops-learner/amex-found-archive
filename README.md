# Scripts

## api_dependencies.sh

This script provides a way to identify dependencies between different Google Cloud APIs. It does so by disabling all APIs in the current default project and enabling a single API.

Some examples are provided below.

### redis

```
> bash api_dependencies.sh redis
- the following services were enabled as a consequence of [redis]:
bigquery.googleapis.com
bigquerystorage.googleapis.com
cloudtrace.googleapis.com
compute.googleapis.com
container.googleapis.com
containerregistry.googleapis.com
deploymentmanager.googleapis.com
iam.googleapis.com
iamcredentials.googleapis.com
logging.googleapis.com
monitoring.googleapis.com
oslogin.googleapis.com
pubsub.googleapis.com
redis.googleapis.com
storage-api.googleapis.com
storage-component.googleapis.com
```

### anthos

```
> bash api_dependencies.sh anthos
- the following services were enabled as a consequence of [anthos]:
anthos.googleapis.com
bigquery.googleapis.com
bigquerystorage.googleapis.com
compute.googleapis.com
container.googleapis.com
containerregistry.googleapis.com
gkeconnect.googleapis.com
gkehub.googleapis.com
iam.googleapis.com
iamcredentials.googleapis.com
monitoring.googleapis.com
multiclustermetering.googleapis.com
oslogin.googleapis.com
pubsub.googleapis.com
storage-api.googleapis.com
```

### cloudbuild

```
> bash api_dependencies.sh cloudbuild
- the following services were enabled as a consequence of [cloudbuild]:
cloudbuild.googleapis.com
containerregistry.googleapis.com
logging.googleapis.com
pubsub.googleapis.com
storage-api.googleapis.com
```

## validator.py

The script validator.py provides a proof-of-concept for a validation procedure for terraform plans. It works by reading the json output of a terraform plan, identifying all the resources to be created in the plan and executing validations for each resource.


### Simple usage

To execute the script, first generate a terraform plan:


```
> terraform plan -out out.plan
```

this will generate a binary file with the plan. Next, use terraform show to generate a json file and pipe that through the validator, eg:

```
> terraform show -json out.plan | python validator.py
```

this will identify all the resources in the plan and will run custom validations for each resource based on the type. A sample output for  a terraform plan that creates a project and some bigquery resources looks like:

```
> terraform show -json out.plan | python3 validator.py
INFO:root:terraform plan detected
WARNING:root:validator not implemented [google_bigquery_dataset]
WARNING:root:validator not implemented [google_bigquery_table]
WARNING:root:validator not implemented [google_bigquery_table]
WARNING:root:validator not implemented [null_data_source]
INFO:root:validated [module.project.module.project.module.project-factory.google_project.main]
ERROR:root:service accounts should have a description
INFO:root:validated [module.project.module.project.module.project-factory.google_service_account.default_service_account]
WARNING:root:validator not implemented [null_resource]
WARNING:root:validator not implemented [random_id]
```

where a custom validation has been implemented requiring service accounts to contain a description.

### Custom rules

The validation of a terraform resource is done based on the 'type' field in it's json representation. For example a bigquery dataset is represented by the following json blob:

```
{
  "address": "module.bigquery.google_bigquery_dataset.default",
  "mode": "managed",
  "type": "google_bigquery_dataset",
  "name": "default",
  "provider_name": "google",
  "schema_version": 0,
  "values": {
    "dataset_id": "sample_dataset",
    "default_encryption_configuration": [],
    "default_partition_expiration_ms": null,
    "default_table_expiration_ms": null,
    "delete_contents_on_destroy": false,
    "description": "managed by terraform",
    "friendly_name": "Sample Dataset",
    "labels": {
      "tag1": "value1"
    },
    "location": "US",
    "timeouts": null
  }
}
```

where the type is `google_bigquery_dataset`.

To validate this type of resource a function named validate_google_bigquery_dataset is added to the validator.py, an example of such a function could validate that delete_contents_on_destroy is set to false:

```
def validate_google_bigquery_dataset(bq):
   assert bq['values']['delete_contents_on_destroy'] == False
```





# amex-found-archive
