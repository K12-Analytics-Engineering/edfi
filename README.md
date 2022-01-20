## Deploying Ed-Fi on Google Cloud
This repository contains all code and instructions to deploy the Ed-Fi Platform to Google Cloud. This README will walk you through how to deploy the Ed-Fi ODS on Google Cloud SQL as well as the Ed-Fi API and Admin App on Google Cloud Run.

This repository is designed to be cloned in Google Cloud Shell.

### Set Project ID
Run the command below to configure Cloud Shell to use the appropriate Google Cloud project.

```bash
gcloud auth login;
gcloud config set project <REPLACE-WITH-PROJECT-ID>;
```

## Ed-Fi ODS

### Enable APIs and download artifacts
The first script will enable the necessary Google APIs in the Cloud project, download ODS backup files, and unzip the downloaded files so they are ready to be imported once you have your Cloud SQL instance created.

```bash
bash edfi-ods/001-init.sh;
```

### Create Cloud SQL instance
The second script will create a Cloud SQL instance as well as the empty ODS databases that you'll import data into later on.

```bash
bash edfi-ods/002-create-cloud-sql.sh $GOOGLE_CLOUD_PROJECT;
```

Navigate to your newly created Cloud SQL [instance](https://console.cloud.google.com/sql/instances/edfi-ods-db/users) to set the password for the *postgres* user.


### Import ODS data
Before we run the third script, we need to create a connection to the Cloud SQL instance. Run the command below replacing `<INSTANCE_CONNECTION_NAME>` with your Cloud SQL connection name found [here](https://console.cloud.google.com/sql/instances/ods/overview?cloudshell=true&folder) or on the Overview page of your Cloud SQL instance.

```bash
cloud_sql_proxy -instances=<INSTANCE_CONNECTION_NAME>=tcp:5432;
```

Leave `cloud_sql_proxy` running and open a new tab under Cloud Shell. Run the third script to import the ODS data. You will be prompted for your *postgres* password at the start of each import.

```bash
gcloud auth login;
gcloud config set project <REPLACE-WITH-PROJECT-ID>;
cd edfi;
bash edfi-ods/003-import-ods-data.sh <POSTGRES_PASSWORD>;
```

That's it for the ODS! You now have an Ed-Fi ODS created and your databases seeded with data.


### Create your Secrets
Navigate to [Secret Manager](https://console.cloud.google.com/security/secret-manager) under the *IAM & Admin* menu.

#### Ed-Fi ODS postgres password

* Create a new secret with the name `ods-password`
* Enter your *postgres* user's password as the value
* Click **Create Secret**

#### Ed-Fi Admin App encryption key

* Create a new secret with the name `admin-app-encryption-key`
* Store the output of the command below

```bash
/usr/bin/openssl rand -base64 32
```

## Ed-Fi API
Time to deploy the API on Google Cloud Run. You'll notice a few files in the `edfi-api` folder that we will use to deploy the API. These files were created by the Ed-Fi Team Team who has created a more generalized [Docker repository](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker).

```bash
bash edfi-api/001-deploy-api.sh $GOOGLE_CLOUD_PROJECT;
```

## Ed-Fi Admin App
Ed-Fi's Admin App be deployed to Google Cloud Run as a separate application.

```bash
bash edfi-admin-app/001-deploy-admin-app.sh $GOOGLE_CLOUD_PROJECT <CLOUD_RUN_EDFI_API_URL>;
```