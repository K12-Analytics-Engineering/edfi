# Deploying Ed-Fi in Google Cloud

![Ed-Fi](https://www.ed-fi.org/assets/2019/07/Ed-FiLogo-2.png)

In this tutorial you will deploy Ed-Fi. This includes:
* Ed-Fi API and ODS Suite 3 v6.1
* Ed-Fi Admin App v3
* TPDM Core v1.1.0

Your Ed-Fi API will run in `YearSpecific` mode allowing for your ODSes to be segmented by school year, but all accessible via the API. Your ODS will be PostgreSQL v13.

This tutorial focuses on the steps necessary to deploy Ed-Fi in Google Cloud. If you find yourself curious about specific pieces and wanting to go deeper with understanding Google Cloud, [Qwiklabs](https://www.qwiklabs.com/) and [Coursera](https://www.coursera.org/professional-certificates/gcp-data-engineering) are great resources.

**Prerequisites**: A Cloud Billing account

<walkthrough-tutorial-duration duration="75"></walkthrough-tutorial-duration>

## Google Cloud project

<walkthrough-project-setup billing="true"></walkthrough-project-setup>

If you created a project via the link above, be sure to also select it from the dropdown.

Click the **Start** button to move to the next step.

## Initial setup
### Configure Cloud Shell

Run the command below to configure Cloud Shell to use the appropriate Google Cloud project.

Note there are two buttons above the command snippet to make it easier to run the commands in Cloud Shell. The one on the left will copy the command directly into the terminal for you.

```sh
gcloud config set project <walkthrough-project-id/>;
```

### Enable APIs
`gcloud` commands will be run in Google Cloud Shell to create various resources in your Google Cloud project. To do so, the Google Cloud APIs below need to be enabled.

<walkthrough-enable-apis apis="sqladmin.googleapis.com,run.googleapis.com,cloudbuild.googleapis.com,compute.googleapis.com,secretmanager.googleapis.com,servicenetworking.googleapis.com,artifactregistry.googleapis.com"></walkthrough-enable-apis>

After all APIs show a green check mark, click the **Next** button.


## Cloud SQL instance

![Cloud SQL](https://walkthroughs.googleusercontent.com/content/images/cloud_SQL.png)

Next up you will create a PostgreSQL Cloud SQL instance that will house your Ed-Fi ODS. This SQL instance has 1 vCPUs and 6 GB of RAM and costs around $60/month. If you find your database needs grow over time, you are able to edit the instance later to add more compute and memory. Storage will start at 10 GB and increase automatically as needed.

```sh
gcloud beta sql instances create \
    --zone us-central1-c \
    --database-version POSTGRES_13 \
    --memory 6144MiB \
    --cpu 1 \
    --storage-auto-increase \
    --database-flags max_connections=250 \
    --require-ssl \
    --backup-start-time 08:00 edfi-ods-db;
```

Click the button below and navigate to your Cloud SQL instance.

<walkthrough-menu-navigation sectionId="SQL_SECTION"></walkthrough-menu-navigation>

Your Cloud SQL instance has finished being created when you see a green check mark next to it.

### Admin and Security databases
Now that your Cloud SQL instance has been created, time to create the necessary databases.

The commands below will create your `EdFi_Admin` and `EdFi_Security` databases from database backup files.

`EdFi_Admin`
```sh
gcloud sql databases create 'EdFi_Admin' --instance=edfi-ods-db;
```
```sh
gcloud sql import sql edfi-ods-db gs://edfi-public-resources/edfi_admin_db_6.1.45.sql \
    --database 'EdFi_Admin' \
    --user postgres;
```

`EdFi_Security`
```sh
gcloud sql databases create 'EdFi_Security' --instance=edfi-ods-db;
```
```sh
gcloud sql import sql edfi-ods-db gs://edfi-public-resources/edfi_security_db_6.1.56.sql \
    --database 'EdFi_Security' \
    --user postgres;
```

### Minimal or Populated

Below are commands for creating the ODS databases from the Ed-Fi Alliance's minimal and populated templates. Use the minimal templates if you want an empty ODS to load your district's data into. Use the populated template if you'd like an ODS populated with fake student data.

**Minimal**

`EdFi_Ods_2024`
```sh
gcloud sql databases create 'EdFi_Ods_2024' --instance=edfi-ods-db;
```
```sh
gcloud sql import sql edfi-ods-db gs://edfi-public-resources/edfi_minimal_tpdm_core_6.1.135.sql \
    --database 'EdFi_Ods_2024' \
    --user postgres;
```
`EdFi_Ods_2023`
```sh
gcloud sql databases create 'EdFi_Ods_2023' --instance=edfi-ods-db;
```
```sh
gcloud sql import sql edfi-ods-db gs://edfi-public-resources/edfi_minimal_tpdm_core_6.1.135.sql \
    --database 'EdFi_Ods_2023' \
    --user postgres;
```
`EdFi_Ods_2022`
```sh
gcloud sql databases create 'EdFi_Ods_2022' --instance=edfi-ods-db;
```
```sh
gcloud sql import sql edfi-ods-db gs://edfi-public-resources/edfi_minimal_tpdm_core_6.1.135.sql \
    --database 'EdFi_Ods_2022' \
    --user postgres;
```
`EdFi_Ods_2021`
```sh
gcloud sql databases create 'EdFi_Ods_2021' --instance=edfi-ods-db;
```
```sh
gcloud sql import sql edfi-ods-db gs://edfi-public-resources/edfi_minimal_tpdm_core_6.1.135.sql \
    --database 'EdFi_Ods_2021' \
    --user postgres;
```

**Populated**

```sh
gcloud sql databases create 'EdFi_Ods_2023' --instance=edfi-ods-db;
```
```sh
gcloud sql import sql edfi-ods-db gs://edfi-public-resources/edfi_populated_tpdm_core_5.3.224.sql \
    --database 'EdFi_Ods_2023' \
    --user postgres;
```

### Set your postgres user password
Now that your Cloud SQL instance has been created, you will need to set the password for the postgres user.

* Click on **edfi-ods-db**
* Click on **Users**
* Click on the three-dot menu and set the password for the *postgres* user

After you have set the `postgres` user's password, click the **Next** button.


## Create your Secrets
Your Ed-Fi API and Admin App will need to access two pieces of sensitive information: your `postgres` user's password and an encryption key specific to your Admin App deployment. Instead of storing these in plain text inside your respective configuration, we will use Google's Secret Manager. This is a great way to save sensitive information in an encrypted, secure manner.

### Ed-Fi ODS password
Run the command below. You should replace *`<POSTGRES_PASSWORD>`* with your actual `postgres` user password.
```sh
echo -n '<POSTGRES_PASSWORD>' | gcloud secrets create ods-password --data-file=-
```

### Admin App encryption key
Run the command below. 
```sh
echo -n $(/usr/bin/openssl rand -base64 32) | gcloud secrets create admin-app-encryption-key --data-file=-
```

Once you have your two new secrets created, click the **Next** button.

## Service account
Your Ed-Fi API and Admin App will run via Cloud Run. Those services will run under a service account that has access to your Cloud SQL instance and recently created secrets.

Run the commands below to create your service account and grant it access to the appropriate services.

```sh
gcloud iam service-accounts create edfi-cloud-run;
```

Grant the service acccount permission to connect to Cloud SQL
```sh
gcloud projects add-iam-policy-binding <walkthrough-project-id/> \
    --member="serviceAccount:edfi-cloud-run@<walkthrough-project-id/>.iam.gserviceaccount.com" \
    --role=roles/cloudsql.client;
```

Grant the service acccount permission to access your `ods-password` secret
```sh
gcloud beta secrets add-iam-policy-binding projects/<walkthrough-project-id/>/secrets/ods-password \
--member serviceAccount:edfi-cloud-run@<walkthrough-project-id/>.iam.gserviceaccount.com \
--role roles/secretmanager.secretAccessor;
```

Grant the service acccount permission to access your `admin-app-encryption-key` secret
```sh
gcloud beta secrets add-iam-policy-binding projects/<walkthrough-project-id/>/secrets/admin-app-encryption-key \
--member serviceAccount:edfi-cloud-run@<walkthrough-project-id/>.iam.gserviceaccount.com \
--role roles/secretmanager.secretAccessor;
```

Click the **Next** button.


## Ed-Fi API

![Cloud Run](https://cloud-dot-devsite-v2-prod.appspot.com/walkthroughs/images/run.png)

Time to deploy the Ed-Fi API via Google Cloud Run. Run the command below to build a Docker image and push the image to your Google Cloud Container Registry.

```sh
gcloud artifacts repositories create edfi \
    --repository-format=docker \
    --location=us-central1;
```

```sh
gcloud builds submit --tag us-central1-docker.pkg.dev/<walkthrough-project-id/>/edfi/edfi-api edfi-api/;
```

Now that you have an image in your Google Cloud project, you can deploy a Cloud Run service that uses that image to deploy an application. The command below will deploy an Ed-Fi API where each container instance has 2 vCPUs and 2 GB of memory. The Cloud Run service will scale to zero and scale up to a maximum of 3 instances. By default a Cloud Run service can scale up to 100 containers. We do not want that since our Cloud SQL instance can only have a specific number of concurrent connections. See more on [YouTube](https://www.youtube.com/watch?v=K2cn40Jyxqg) to understand right-sizing your Ed-Fi API and ODS.

```sh
gcloud beta run deploy edfi-api \
    --image us-central1-docker.pkg.dev/<walkthrough-project-id/>/edfi/edfi-api \
    --add-cloudsql-instances <walkthrough-project-id/>:us-central1:edfi-ods-db \
    --port 80 \
    --region us-central1 \
    --cpu 2 \
    --memory 2Gi \
    --allow-unauthenticated \
    --update-env-vars DB_HOST=<walkthrough-project-id/>:us-central1:edfi-ods-db \
    --set-secrets=DB_PASS=ods-password:1 \
    --service-account edfi-cloud-run@<walkthrough-project-id/>.iam.gserviceaccount.com \
    --min-instances 0 \
    --max-instances 3 \
    --platform managed;
```

Your Cloud Run service has finished being created when you see a service URL logged to Cloud Shell. Navigate to the URL to see metadata related to your Ed-Fi API.

Click the **Next** button.

## Ed-Fi Admin App

![Cloud Run](https://cloud-dot-devsite-v2-prod.appspot.com/walkthroughs/images/run.png)

The final step is to deploy Ed-Fi's Admin App via Google Cloud Run. Run the command below to build a Docker image and push the image to your Google Cloud Container Registry.

```sh
gcloud builds submit --tag gcr.io/<walkthrough-project-id/>/edfi-admin-app edfi-admin-app/;
```

Now that you have an image in your Google Cloud project, you can deploy a Cloud Run service that uses that image to deploy an application. The command below will deploy an Ed-Fi API where each container instance has 2 vCPUs and 1 GB of memory. The Cloud Run service will scale to zero and scale up to a maximum of just 1 instance.

```sh
gcloud beta run deploy edfi-admin-app \
    --image us-central1-docker.pkg.dev/<walkthrough-project-id/>/edfi/edfi-admin-app \
    --add-cloudsql-instances <walkthrough-project-id/>:us-central1:edfi-ods-db \
    --port 80 \
    --region us-central1 \
    --cpu 2 \
    --memory 1Gi \
    --concurrency 50 \
    --min-instances 0 \
    --max-instances 1 \
    --allow-unauthenticated \
    --update-env-vars PROJECT_ID=<walkthrough-project-id/>,API_URL=$(gcloud beta run services describe edfi-api --region us-central1 --format="get(status.url)") \
    --set-secrets=DB_PASS=ods-password:1,ENCRYPTION_KEY=admin-app-encryption-key:1 \
    --service-account edfi-cloud-run@<walkthrough-project-id/>.iam.gserviceaccount.com \
    --platform managed;

```

After the Cloud Run service has been deployed, the terminal will print out a *Service URL* for your Admin App deployment. Navigate to the URL to create an admin account.

Click the **Next** button.

## Congratulations!
You have successfully deployed Ed-Fi on Google Cloud.

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>
