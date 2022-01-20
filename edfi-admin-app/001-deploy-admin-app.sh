gcloud builds submit --tag gcr.io/$1/edfi-admin-app edfi-admin-app/;

gcloud beta run deploy edfi-admin-app \
    --image gcr.io/$1/edfi-admin-app \
    --add-cloudsql-instances $1:us-central1:edfi-ods-db \
    --port 80 \
    --region us-central1 \
    --cpu 2 \
    --memory 1Gi \
    --concurrency 50 \
    --max-instances 1 \
    --allow-unauthenticated \
    --update-env-vars PROJECT_ID=$1,API_URL=$2 \
    --set-secrets=DB_PASS=ods-password:1,ENCRYPTION_KEY=admin-app-encryption-key:1 \
    --service-account edfi-cloud-run@$1.iam.gserviceaccount.com \
    --platform managed;
