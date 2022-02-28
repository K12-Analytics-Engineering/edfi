# Deploying Ed-Fi in Google Cloud

![Ed-Fi](https://www.ed-fi.org/assets/2019/07/Ed-FiLogo-2.png)

This tutorial will walk you through deploying the Ed-Fi ODS on Google Cloud SQL as well as the Ed-Fi API and Admin App on Google Cloud Run.

**Time to complete**: About 45 minutes

**Prerequisites**: A Cloud Billing account

Click the **Start** button to move to the next step.

## Set Project ID
Run the command below to configure Cloud Shell to use the appropriate Google Cloud project. Replace `<REPLACE-WITH-PROJECT-ID>` with your actual Google Cloud project ID.

```bash
gcloud config set project <REPLACE-WITH-PROJECT-ID>;
```

## Enable Google APIs and download artifacts

<walkthrough-enable-apis apis="sqladmin.googleapis.com,run.googleapis.com"></walkthrough-enable-apis>

The first script will enable the necessary Google APIs in the Cloud project, download ODS backup files, and unzip the downloaded files so they are ready to be imported once you have your Cloud SQL instance created.

```bash
bash edfi-ods/001-init.sh;
```

## Create Cloud SQL instance
The second script will create a Cloud SQL instance as well as the empty ODS databases that you'll import data into later on.

```bash
bash edfi-ods/002-create-cloud-sql.sh $GOOGLE_CLOUD_PROJECT;
```

Navigate to your newly created Cloud SQL [instance](https://console.cloud.google.com/sql/instances/edfi-ods-db/users) to set the password for the *postgres* user.
