# Deploying Ed-Fi in Google Cloud

![Ed-Fi](https://www.ed-fi.org/assets/2019/07/Ed-FiLogo-2.png)

This tutorial will walk you through deploying the Ed-Fi API, ODS, and Admin App in Google Cloud. Cloud SQL will be used for the ODS, and Cloud Run will be used for the API and Admin App.

Your Ed-Fi API will run in `YearSpecific` mode allowing for your ODSes to be segmented by school year, but all accessible via the API.

<walkthrough-tutorial-duration duration="45"></walkthrough-tutorial-duration>

<walkthrough-project-setup billing="true" ></walkthrough-project-setup>

**Prerequisites**: A Cloud Billing account

## Set Project ID
Run the command below to configure Cloud Shell to use the appropriate Google Cloud project. Replace `<REPLACE-WITH-PROJECT-ID>` with <walkthrough-project-id/>.

```sh
gcloud config set project <REPLACE-WITH-PROJECT-ID> <walkthrough-project-id/>;
```

Click the **Start** button to move to the next step.

## Enable Google APIs
`gcloud` commands will be run in Google Cloud Shell to create various resources in your Google Cloud project. Click **Enable APIs** to enable the APIs listed.

<walkthrough-enable-apis apis="sqladmin.googleapis.com,run.googleapis.com,cloudbuild.googleapis.com,compute.googleapis.com,secretmanager.googleapis.com,servicenetworking.googleapis.com"></walkthrough-enable-apis>

Click the **Next** button.

## Download Ed-Fi artifacts
Copy and run the command below. This will download the various files needed from Ed-Fi and store them in the `artifacts/` folder in the root of this folder.


```sh
bash edfi-ods/001-init.sh;
```

Click the **Next** button.

## Create your Cloud SQL instance
You now need to create your Cloud SQL instance running PostgreSQL. This is the Ed-Fi ODS. After the Cloud SQL instance is created, this script will also create the following empty databases:

* EdFi_Admin
* EdFi_Security
* EdFi_Ods_2023
* EdFi_Ods_2022
* EdFi_Ods_2021

```sh
bash edfi-ods/002-create-cloud-sql.sh $GOOGLE_CLOUD_PROJECT;
```

## Set postgres user password
Now that your Cloud SQL instance has been created, you will need to set the password for the postgres user. Click [here](https://console.cloud.google.com/sql/instances/edfi-ods-db/users) and set the password for the *postgres* user.
