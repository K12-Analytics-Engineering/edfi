# Deploying Ed-Fi in Google Cloud

![Ed-Fi](https://www.ed-fi.org/assets/2019/07/Ed-FiLogo-2.png)

This tutorial will walk you through deploying the Ed-Fi API, ODS, and Admin App in Google Cloud. Cloud SQL will be used for the ODS, and Cloud Run will be used for the API and Admin App.

Your Ed-Fi API will run in `YearSpecific` mode allowing for your ODSes to be segmented by school year, but all accessible via the API.

**Prerequisites**: A Cloud Billing account

<walkthrough-tutorial-duration duration="45"></walkthrough-tutorial-duration>

<walkthrough-project-setup billing="true" ></walkthrough-project-setup>

If you created a project via the link above, be sure to also select it from the dropdown.

## Set Project ID
Run the command below to configure Cloud Shell to use the appropriate Google Cloud project.

```sh
gcloud config set project <walkthrough-project-id/>;
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


## Cloud SQL instance

## Create instance
You now need to create your Cloud SQL instance running PostgreSQL. This is the Ed-Fi ODS. After the Cloud SQL instance is created, this script will also create the following empty databases:

* EdFi_Admin
* EdFi_Security
* EdFi_Ods_2023
* EdFi_Ods_2022
* EdFi_Ods_2021

```sh
bash edfi-ods/002-create-cloud-sql.sh <walkthrough-project-id/>;
```

### Set postgres user password
Now that your Cloud SQL instance has been created, you will need to set the password for the postgres user. Click [here](https://console.cloud.google.com/sql/instances/edfi-ods-db/users) and set the password for the *postgres* user.

Click the **Next** button.


## Import ODS data
You are now going to seed your various PostgreSQL databases with the table structures required by Ed-Fi.

### Proxy into instance
Cloud SQL proxy is a command-line tool used to connect to a Cloud SQL instance. This tool creates an encrypted tunnel between your Cloud Shell environment and your Cloud SQL instance allowing you to connect to it and run various commands.

```bash
cloud_sql_proxy -instances=<walkthrough-project-id/>:us-central1:edfi-ods-db=tcp:5432;
```

The command above will stay open and continue running while we execute the next step. 

<walkthrough-editor-spotlight spotlightId="menu-terminal-new-terminal">Open a new terminal</walkthrough-editor-spotlight> and run the third script to import the ODS data. You will be prompted for your *postgres* password at the start of each import.

```sh
gcloud config set project <walkthrough-project-id/>;
bash edfi-ods/003-import-ods-data.sh '<POSTGRES_PASSWORD>';
```

That's it for the ODS! You now have an Ed-Fi ODS created and your databases seeded with data.

Click the **Next** button to deploy your Ed-Fi API.
