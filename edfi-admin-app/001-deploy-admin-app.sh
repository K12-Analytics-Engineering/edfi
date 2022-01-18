gcloud builds submit --tag gcr.io/$1/edfi-admin-app-$3 edfi-admin-app/$3;

gcloud beta run deploy edfi-admin-app-$3 \
--image gcr.io/$1/edfi-admin-app-$3 \
--add-cloudsql-instances $1:us-central1:edfi-ods-db \
--port 80 \
--region us-central1 \
--cpu 2 \
--memory 1Gi \
--concurrency 50 \
--max-instances 1 \
--allow-unauthenticated \
--update-env-vars PROJECT_ID=$1,ENCRYPTION_KEY=$(/usr/bin/openssl rand -base64 32),API_URL=$2 \
--set-secrets=DB_PASS=ods-password:1 \
--service-account edfi-cloud-run@$1.iam.gserviceaccount.com \
--platform managed;
