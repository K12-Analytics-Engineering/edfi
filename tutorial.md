# Deploying Ed-Fi in Google Cloud

![Ed-Fi](https://www.ed-fi.org/assets/2019/07/Ed-FiLogo-2.png)

This tutorial will walk you through deploying the Ed-Fi API, ODS, and Admin App in Google Cloud. Cloud SQL will be used for the ODS, and Cloud Run will be used for the API and Admin App.

Your Ed-Fi API will run in `YearSpecific` mode allowing for your ODSes to be segmented by school year, but all accessible via the API.

**Prerequisites**: A Cloud Billing account

<walkthrough-tutorial-duration duration="45"></walkthrough-tutorial-duration>

<walkthrough-project-setup billing="true" ></walkthrough-project-setup>

If you created a project via the link above, be sure to also select it from the dropdown.

## Configure Cloud Shell

Run the command below to configure Cloud Shell to use the appropriate Google Cloud project.

```sh
gcloud config set project <walkthrough-project-id/>;
```

Click the **Start** button to move to the next step.

## Initial setup
`gcloud` commands will be run in Google Cloud Shell to create various resources in your Google Cloud project.

Run the command below. This will enable the necessary Google Cloud APIs and download the various files needed from Ed-Fi.


```sh
bash edfi-ods/001-init.sh;
```

After the command above has finished, click the **Next** button.


## Cloud SQL instance

### Create instance
Next up you will create a PostgreSQL Cloud SQL instance. This is the Ed-Fi ODS. After the Cloud SQL instance is created, this script will also create the following empty databases:

* EdFi_Admin
* EdFi_Security
* EdFi_Ods_2023
* EdFi_Ods_2022
* EdFi_Ods_2021

```sh
bash edfi-ods/002-create-cloud-sql.sh <walkthrough-project-id/>;
```

After the command above has finished, move on to the next section.

### Set postgres user password
Now that your Cloud SQL instance has been created, you will need to set the password for the postgres user. Click [here](https://console.cloud.google.com/sql/instances/edfi-ods-db/users) and set the password for the *postgres* user.

After you have set the `postgres` user's password, click the **Next** button.


## Import ODS data
You are now going to seed your various PostgreSQL databases with the table structures required by Ed-Fi.

### Proxy into instance
Cloud SQL proxy is a command-line tool used to connect to a Cloud SQL instance. This tool creates an encrypted tunnel between your Cloud Shell environment and your Cloud SQL instance allowing you to connect to it and run various commands.

```bash
cloud_sql_proxy -instances=<walkthrough-project-id/>:us-central1:edfi-ods-db=tcp:5432;
```

The command above will stay open and continue running while we execute the next step. 

Click <walkthrough-open-cloud-shell-button></walkthrough-open-cloud-shell-button> to open a new terminal. Run the command below to import the ODS data. You should replace `<POSTGRES_PASSWORD>` with your actual `postgres` user password.

```sh
bash edfi-ods/003-import-ods-data.sh '<POSTGRES_PASSWORD>';
```

That's it for the ODS! You now have an Ed-Fi ODS created and your databases seeded with data.

Click the **Next** button.


## Create your Secrets
Your Ed-Fi API and Admin App will need to access two pieces of sensitive information: your `postgres` user's password and an encryption key specific to your Admin App deployment. Instead of storing these in plain text inside your respective configuration, we will use Google's Secret Manager. This is a great way to save sensitive information in an encrypted, secure manner.

Navigate to [Secret Manager](https://console.cloud.google.com/security/secret-manager) under the *IAM & Admin* menu. Complete the steps below to create two new secrets.

### Ed-Fi ODS postgres password

* Create a new secret with the name `ods-password`
* Enter your *postgres* user's password as the value
* Click **Create Secret**

### Ed-Fi Admin App encryption key

* Create a new secret with the name `admin-app-encryption-key`
* Store the output of the command below

```sh
/usr/bin/openssl rand -base64 32
```

Once you have your two new secrets created, click the **Next** button.


## Ed-Fi API
Time to deploy the API on Google Cloud Run. Running the command below will build a Docker image using this <walkthrough-editor-open-file filePath="edfi-api/appsettings.template.json">Ed-Fi API config</walkthrough-editor-open-file> and push the image to your Google Cloud Container Registry. After that, a Cloud Run service will be deployed using that new image.

```sh
bash edfi-api/001-deploy-api.sh <walkthrough-project-id/>;
```

After the Cloud Run service has been deployed, the terminal will print out the HTTPS URL for your Ed-Fi API. Test the API by navigating to this URL.

Click the **Next** button.

## Ed-Fi Admin App
The final step is to deploy Ed-Fi's Admin App as an additional Google Cloud Run service. Run the command below replacing `<CLOUD_RUN_EDFI_API_URL>` with the Ed-Fi API generated via the previous step.

```sh
bash edfi-admin-app/001-deploy-admin-app.sh <walkthrough-project-id/> <CLOUD_RUN_EDFI_API_URL>;
```

After the Cloud Run service has been deployed, the terminal will print out the HTTPS URL for your Admin App deployment. Navigate to the URL to create an admin account.

Click the **Next** button.

## Congratulations!
That is it! You have successfully deployed Ed-Fi on Google Cloud.

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>
