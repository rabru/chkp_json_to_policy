# Check Point policy deployment based on json

This is an example how you can deploy an inline policy and install a rule set based on a json file into it.

## Preparations 

- Clone the repository and change working directory
```
git clone https://github.com/rabru/chkp_json_to_policy
cd chkp_json_to_policy
```

- Depending on the management system used add the needed credentials in the ´Smart1´ or ´Smart1 Cloud´ part in `terraform.tfvars.example`.
- Rename `terraform.tfvars.example` to `terraform.tfvars`
```
mv terraform.tfvars.example terraform.tfvars
```

- Remove the checkpoint provider setup of the unused management system out of `main.tf`. ´Smart1´ is enabled by default.

```
/*
# Smart1 Cloud
provider "checkpoint" {
  server = "${var.portal}"
  api_key = "${var.api_key}"
  cloud_mgmt_id = "${var.cloud_mgmt_id}"
  auto_publish_batch_size = 1
}
*/

# Smart1
provider "checkpoint" {
  server = "${var.server}"
  username = "${var.user}"
  password = "${var.password}"
  auto_publish_batch_size = 1
}
```

## Deployment of the policy

The deployment is split into two parts:
- Creation of the policy deployment script
- The deployment itself

### Creation of the policy deployment script

The creation is done in the subfolder `create`
```
cd create
```

The policy is defined in the `inline-policy.json` file. The policies will be deployed in order as they are configured in the json file. There is official no order in json, but it works anyway. Feel free to adapt this file according to your needs.

Now we can start the creation:

```
terraform init
terraform apply
```

This will create `../inline-rules.tf`

Validate the script before you continue.

### The deployment

If you start the script as given, this will include the inline policy on the botton, after your cleanup rule. Therefore, it shouldn't do any harm to the existing setup.

```
cd ..
terraform init
terraform apply
```

### Remove the deployment

To clean up the deployment use the following command.

```
terraform destroy
```


