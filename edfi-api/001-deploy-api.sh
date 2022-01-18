gcloud builds submit --tag gcr.io/$1/edfi-api edfi-api/;

gcloud projects add-iam-policy-binding $1 \
    --member="serviceAccount:edfi-cloud-run@$1.iam.gserviceaccount.com" \
    --role=roles/cloudsql.client;

gcloud beta secrets add-iam-policy-binding projects/$1/secrets/ods-password \
--member serviceAccount:edfi-cloud-run@$1.iam.gserviceaccount.com \
--role roles/secretmanager.secretAccessor;

gcloud beta run deploy edfi-api \
--image gcr.io/$1/edfi-api \
--add-cloudsql-instances $1:us-central1:edfi-ods-db \
--port 80 \
--region us-central1 \
--cpu 2 \
--memory 2Gi \
--allow-unauthenticated \
--update-env-vars PROJECT_ID=$1 \
--set-secrets=DB_PASS=ods-password:1 \
--service-account edfi-cloud-run@$1.iam.gserviceaccount.com \
--platform managed;
