# Atlantis bootstrap

## Purpose

This Terraform-module, Kustomize templates and installation guide will help you create an [Atlantis](https://www.runatlantis.io) setup running on GKE. Infrastructure and services that will be created and configured are:

* A GCP-project
* A GKE-cluster running in the project
* Cert-manager running in the cluster
* Atlantis running in the cluster
* All needed certificates, keys and secrets
* Cloud Armor for securing the applications
* GitHub App which connects Atlantis to one or more repositories containing Terraform config

When this setup is completed you should be able to control your infrastructure on GCP using the Atlantis installation.

## Prerequisites

* `gcloud`, `kubectl` and `terraform` installed on your machine
* An `organisation` on GCP
* A `seed project` (installation guide below)
* `Azure DNS` to handle DNS A record creation and DNS-01 challenge for certificate issuance.
* A `GitHub organisation` or account (Any VCS should work but this guide uses GitHub)
* A `config-repository` to store the config you create when following this guide
* Somewhere to `store the Terraform state`. This could be a storage bucket of some kind for remote state, or a local folder if you just want to use local state. Remote state is preferred

## Versioning

To avoid breaking changes you should always use a specific release version of this repository in your configuration. The three files specifying versions in your config repo are (see the `example directory`):

* `main.tf`
* `kubernetes-manifests/runfirst/kustomization.yaml`
* `kubernetes-manifests/atlantis-statefulset/kustomization.yaml`

## Terraform compability

This module is meant for use with Terraform 0.13.

## Usage

The bootstrapping consists of four parts. The first part uses Terraform to create the base infrastructure for the later Atlantis installation. The second part uses kubectl to install applications (cert-manager and Atlantis) in Kubernetes. Part three creates a GitHub app which Atlantis uses to connect to repositories containing Terraform-code. Part four secures access to the Atlantis application.

The installation requires that a seed project is already created using the [helper script](https://github.com/terraform-google-modules/terraform-google-project-factory/blob/master/helpers/setup-sa.sh) from [Google Cloud Project Factory Terraform Module](https://github.com/terraform-google-modules/terraform-google-project-factory).

### Prepare the seed project

Go to `https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=<seed_project_id>` and enable the Kubernetes Engine API if not enabled. This is needed to create the Kubernetes cluster. If not enabled the setup will fail.

### Create base infrastructure

* Start by creating a service account key (credfile) which will be used when running Terraform commands. Follow [these instructions](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating_service_account_keys). The service account to use is the one who starts with "project-factory" in the seed project. Store the JSON-file on your local machine. You need to have the role "service account key admin" on GCP to create the key.

* Create a new repository / local folder which will contain your configuration files. Copy all files and directories in the `example` folder to the new repo/folder.

* IMPORTANT! Rename the file `rename_to_gitignore.txt` to `.gitignore`. This will prevent files with secrets getting committed to Git. These files should be stored in a secure location.

* Update the variable values in `main.tf`.

* Update the values in the `backend.tf` file to reflect the location of your Terraform state file.

* Update the values in `azure.tfvars`. This file is used to authenticate to Azure for DNS.

* Run terraform from the path where `main.tf` is located.

    ```bash
    # Run Terraform init first:
    $ GOOGLE_APPLICATION_CREDENTIALS=/path/to/credfile/ terraform init

    # Terraform plan to to check the execution plan
    $ GOOGLE_APPLICATION_CREDENTIALS=/path/to/credfile/ terraform plan -var-file=azure.tfvars

    # Terraform to apply the changes
    $ GOOGLE_APPLICATION_CREDENTIALS=/path/to/credfile/ terraform apply -var-file=azure.tfvars
    ```

    (If `terraform apply` fails with `Error: googleapi: Error 400: Subnetwork.....is not valid for Network ...., badRequest`; you should run `terraform apply` again)

* Update the files under `kubernetes-manifests/cert-manager` and `kubernetes-manifests/runfirst` as outlined in each file:

  * kubernetes-manifests/cert-manager/cert-manager.yaml
  * kubernetes-manifests/cert-manager/certificate.yaml
  * kubernetes-manifests/runfirst/atlantis-runfirst.yaml
  * kubernetes-manifests/runfirst/ingress.yaml

**Note!** The URL to the Letsencrypt server in `cert-manager.yaml` is `https://acme-staging-v02.api.letsencrypt.org/directory` in the example-directory. This should be changed to `https://acme-v02.api.letsencrypt.org/directory` if creating a production setup.

### Install applications

You should now have a project with a Kubernetes cluster running in GCP. Now it's time to install cert-manager, certificates and a temporary Atlantis setup. Use the following commands to achieve this. Project ID, cluster name, zone and region can be found in the Google Console, if these are not overridden in your config.

```bash
# Set up gcloud. Select "Create a new configuration" and follow on screen guidance to set up gcloud against the newly created atlantis-project
$ gcloud init

# Update kubeconfig file with appropriate credentials and endpoint information to point kubectl at the newly created kubernetes cluster
$ gcloud container clusters get-credentials <CLUSTER NAME> --project <PROJECT ID> --region <REGION>

# Install cert-manager. Check for latest version
$ kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml

# Create TLS certificate
$ kubectl apply -k kubernetes-manifests/cert-manager

# Deploy Atlantis (temporary runfirst config to create Github app. This will be removed in a later stage)
$ kubectl apply -k kubernetes-manifests/runfirst
```

It will take some time before the `kubernetes ingress` for the Atlantis app is ready.

### Create a GitHub App

After the ingress is in a ready state visit your Atlantis-installation at `https://<ATLANTIS_HOST>/github-app/setup` and create an access token following these [instructions](https://www.runatlantis.io/docs/access-credentials.html#github-app). Since your temporary Atlantis deployment is already running, ignore the steps regarding starting and stopping Atlantis.

On the "Github app created successfully" page you will see the `gh-app-id`, `gh-app-key-file` and `gh-webhook-secret`.

Update the files `kubernetes-manifests/atlantis-statefulset/atlantis-statefulset.yaml`
and `kubernetes-manifests/atlantis-statefulset/ingress.yaml` with the new `gh-app-id` and the other outlined variables.

The files `kubernetes-manifests/atlantis-statefulset/gh-webhook-secret` and `kubernetes-manifests/atlantis-statefulset/gh-key-file` also need to be updated to reflect `gh-app-key-file` and `gh-webhook-secret` from the step above.

**Note!** It is important that the `gh-key-file` is kept with this specific format.

**Note!** This guide installs the Atlantis GitHub App in your personal account on GitHub. If you are setting up Atlantis for an organisation, the ownership of this app must be transferred to the organisation. Follow the [GitHub guide](https://developer.github.com/apps/managing-github-apps/transferring-ownership-of-a-github-app/) to move the ownership of the app.

**WARNING!** Only a single Atlantis installation per GitHub App is supported at the moment. This means that if you need a "test-installation" of Atlantis running, it must have its own GitHub App.

Now that the GitHub App is set up, it's time to delete the temporary Atlantis deployment.

```bash
# Delete the "runfirst" deployment
$ kubectl delete -k kubernetes-manifests/runfirst
```

## Deploy Atlantis

```bash
# Deploy Atlantis with the configuration gathered in the previous step.
$ kubectl apply -k kubernetes-manifests/atlantis-statefulset
```

### Secure Atlantis with Cloud Armor

This is achieved by applying the `atlantis-policy` security policy defined in `modules/atlantis/atlantis.tf` to the default Atlantis backend-service. This security policy limits the access to the Atlantis service. The only allowed access is from the GitHub App, and the IPs defined in `master_authorized_networks` in your configuration. The latter is typically the IP to your machine.

There are two backend-services, but the security policy should only be used for the service `default/atlantis`. `gcloud compute backend-services list` lists the name of the backend-services. To figure out which is the right one, run `describe` on each of the backends:

```bash
# Describe the backend service
$ gcloud compute backend-services describe <NAME> --global
```

The backend-service to use has the following content in the output of the above command:
`description: '{"kubernetes.io/service-name":"default/atlantis","kubernetes.io/service-port":"80"}'`.
After having identified the correct backend-service, use its name in the command below:

```bash
# Apply the security policy
$ gcloud compute backend-services update <NAME> --security-policy atlantis-policy --global

# i.e. `gcloud compute backend-services update k8s-be-32687--56e780489a9d9de0 --security-policy atlantis-policy --global`
```

**WARNING!** If a Kubernetes Ingress resource is deleted and then recreated, the security policy must be reapplied to the new backend service or services.

## Terraform modules used by this module

* [project-factory](https://registry.terraform.io/modules/terraform-google-modules/project-factory)
* [kubernetes-engine](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/)
* [address](ttps://registry.terraform.io/modules/terraform-google-modules/address/google/)
* [network](https://registry.terraform.io/modules/terraform-google-modules/network/google/)
* [cloud-nat](ttps://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/)

## Known issues
If Atlantis has full disk, the following error might occur:
```
creating new workspace: mkdir /atlantis/repos/statisticsnorway/platform/1814: no space left on device
```
A solution for this is to remove any active locks and then delete the plugin cache located at `/atlantis/plugin-cache`

A feature request for automatic plugin cache clean up has been issued: https://github.com/runatlantis/atlantis/issues/916

## Contributing

We welcome contributions to this setup! Please fork the repo, create a PR and we'll have a look at it. Please remember that changes to this setup should be reflected in the `example` directory and this README.

## Generated documentation

These docs are generated with [terraform-docs](<https://github.com/terraform-docs/terraform-docs>):

```bash
terraform-docs markdown . --indent 3
```

<!-- BEGINNING OF AUTO-GENERATED DOCS USING terraform-docs -->
### Requirements

No requirements.

### Providers

| Name | Version |
|------|---------|
| google | n/a |

### Modules

| Name | Source | Version |
|------|--------|---------|
| atlantis | ./modules/atlantis | n/a |
| gcp | ./modules/gcp | n/a |
| gke | ./modules/gke | n/a |
| ingress | ./modules/ingress | n/a |

### Resources

| Name | Type |
|------|------|
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account | Billing account ID | `string` | n/a | yes |
| external\_ip\_name | Name of the external IP address resource in GCP | `string` | n/a | yes |
| folder\_id | The ID of a folder to host this project | `string` | `""` | no |
| labels | Labels to use on the project | `map(string)` | `{}` | no |
| master\_authorized\_networks | The list of CIDR blocks of master authorized networks | <pre>list(object({<br>    cidr_block   = string<br>    display_name = string<br>  }))</pre> | n/a | yes |
| org\_id | Google organization ID | `string` | `""` | no |
| project\_id\_prefix | Project prefix ID of the Atlantis project. Also used as cluster name | `string` | `""` | no |
| project\_name | The name of the GCP project created for Atlantis resources | `string` | n/a | yes |
| region | Region in which to create the cluster and run Atlantis. | `string` | `"europe-north1"` | no |
| resource\_group | Azure resource group name | `string` | n/a | yes |
| zone | GCP zone in which to create the cluster and run Atlantis | `string` | `"europe-north1-a"` | no |
| zone\_name | DNS zone name | `string` | n/a | yes |

### Outputs

No outputs.
<!-- END OF AUTO-GENERATED DOCS USING terraform-docs -->
