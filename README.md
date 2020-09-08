# Atlantis bootstrap

## Terraform compability

This module is meant for use with Terraform 0.12.

## Usage

The bootstrapping consist of three parts. The first part uses Terraform to create the base infrastructure. The second part uses kubectl to install applications (cert-manager and Atlantis) in Kubernetes. And part three secures the application.

The installation requires that a seed project is already created using the [helper script](https://github.com/terraform-google-modules/terraform-google-project-factory/blob/master/helpers/setup-sa.sh) from [Google Cloud Project Factory Terraform Module](https://github.com/terraform-google-modules/terraform-google-project-factory).

### Prepare the seed project

Go to https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=<seed_project_id> and enable the Kubernetes Engine API if not enabled. This is needed to create the Kubernetes cluster. If not enabled it will fail to get available Kubernetes cluster versions.

### Create base infrastructure
- Start to create a service account key (credfile) which will be used to run Terraform commands. Follow the instructions at https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating_service_account_keys. The service account to use is the one who starts with "project-factory" in the seed-project.

- Create a new repository/local folder which will contain your configuration files using the `example` folder as a template.

- Update the variable values in `main.tf`

- Update the values in the `backend.tf` file to reflect the location of your Terraform state file.

- Update the values in `azure.tfvars`. This file is used to authenticate to Azure for DNS.

- Run terraform from the path where `main.tf` is located
```bash
# Run Terraform init first:
$ GOOGLE_APPLICATION_CREDENTIALS=/path/to/credfile/ terraform init

# Terraform plan to to check the execution plan
$ GOOGLE_APPLICATION_CREDENTIALS=/path/to/credfile/ terraform plan -var-file=azure.tfvars

# Terraform to apply the changes
$ GOOGLE_APPLICATION_CREDENTIALS=/path/to/credfile/ terraform apply -var-file=azure.tfvars
```
- Update the files under `kubernetes-manifests/cert-manager` and `kubernetes-manifests/runfirst` as outlined.

### Install applications
```bash
# Set up gcloud
$ gcloud init # select "Create a new configuration" and follow on screen guidance to set up gcloud against the newly created atlantis-project.

# Update kubeconfig file with appropriate credentials and endpoint information to point kubectl at the newly created kubernetes cluster.
$ gcloud container clusters get-credentials <CLUSTER NAME>  --project <PROJECT ID> --region europe-north1

# Install cert-manager
$ kubectl apply  -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.yaml # Check for latest version

# Create TLS certificate
$ kubectl apply  -k kubernetes-manifests/cert-manager

# Deploy Atlantis (temporary runfirst config to create Github app)
$ kubectl apply -k kubernetes-manifests/runfirst
```
#### Create a Github App
Visit this URL https://$ATLANTIS_HOST/github-app/setup and follow the instructions here https://www.runatlantis.io/docs/access-credentials.html#generating-an-access-token

On the "Github app created successfully" page you will see the gh-app-id, gh-app-key-file and gh-webhook-secret.
Update the `kubernetes-manifests/atlantis-statefulset/atlantis-statefulset.yaml` with the new gh-app-id and the other outlined variables.   
The files `kubernetes-manifests/atlantis-statefulset/gh-webhook-secret` and `kubernetes-manifests/atlantis-statefulset/gh-key-file` also needs to be updated to reflect gh-app-key-file and gh-webhook-secret from the step above.   
**Note!** It is important that the *gh-key-file* is kept with this specific format.   
**WARNING - Only a single Atlantis installation per GitHub App is supported at the moment**

```bash
# Delete the "runfirst" deployment
$ kubectl delete -k kubernetes-manifests/runfirst
```
# Deploy Atlantis
```bash
$ kubectl apply -k kubernetes-manifests/atlantis-statefulset
```
### Secure Atlantis with Cloud Armor
Note! If a Kubernetes Ingress resource is deleted and then recreated, the security policy must be reapplied to the new backend service or services.
```bash
$ gcloud compute backend-services list

# Run *describe* on the backends:
$ gcloud compute backend-services describe <NAME> --global
```
 There are two backend-services, but only one should be attached to the security policy. In order to find the correct name of the security policy for the "update" command, check for the following content in the output of the above command:   
 `description: '{"kubernetes.io/service-name":"default/atlantis","kubernetes.io/service-port":"80"}'`

```bash
# After having identified the correct backend-service, use it's name in the command below:
$ gcloud compute backend-services update <NAME> --security-policy atlantis-policy --global

# i.e. `gcloud compute backend-services update k8s-be-32687--56e780489a9d9de0 --security-policy atlantis-policy --global`
```

## Terraform modules used by this module

[project-factory](https://registry.terraform.io/modules/terraform-google-modules/project-factory)   
[kubernetes-engine](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/)
[address](ttps://registry.terraform.io/modules/terraform-google-modules/address/google/)
[network](https://registry.terraform.io/modules/terraform-google-modules/network/google/)
[cloud-nat](ttps://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/)

<!-- BEGINNING OF AUTO-GENERATED DOCS USING terraform-docs -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| azurerm | ~> 2.21.0 |
| github | 2.9.2 |
| google | ~> 3.27.0 |

## Providers

No provider.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | The list of apis to activate within the project | `list(string)` | <pre>[<br>  "container.googleapis.com",<br>  "iam.googleapis.com",<br>  "admin.googleapis.com",<br>  "compute.googleapis.com",<br>  "secretmanager.googleapis.com",<br>  "iap.googleapis.com"<br>]</pre> | no |
| billing\_account | Billing account ID | `string` | n/a | yes |
| folder\_id | The ID of a folder to host this project | `string` | `""` | no |
| labels | Labels to use on the project | `map(string)` | `{}` | no |
| org\_id | Google organization ID | `string` | `""` | no |
| project\_id\_prefix | Project prefix ID of the Atlantis project. | `string` | `""` | no |
| project\_name | The name of the GCP project created for Atlantis resources | `string` | n/a | yes |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | `bool` | `true` | no |
| azure\_client\_secret | Azure client secret | `string` | n/a | yes |
| cluster\_name | Cluster name of the Kubernetes cluster | `string` | `""` | no |
| create\_secret | Used to trigger creation of gh-atlantis secrets | `string` | `false` | no |
| gh-key-file | Github App key | `string` | n/a | yes |
| gh-webhook-secret | Github Webhook secret | `string` | n/a | yes |
| master\_authorized\_networks | The list of CIDR blocks of master authorized networks | <pre>list(object({<br>    cidr_block   = string<br>    display_name = string<br>  }))</pre> | n/a | yes |
| project\_id | Project ID of the Atlantis project. | `string` | `""` | no |
| region | Region in which to create the cluster and run Atlantis. | `string` | `"europe-north1"` | no |
| zone | GCP zone in which to create the cluster and run Atlantis | `string` | `"europe-north1-a"` | no |
| zone\_name | DNS zone name | `string` | n/a | yes |
| resource\_group | Azure resource group name | `string` | n/a | yes |

### Outputs

No output.
<!-- END OF AUTO-GENERATED DOCS USING terraform-docs -->
