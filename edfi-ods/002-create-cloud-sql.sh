gcloud compute addresses create google-managed-services-default \
    --global \
    --purpose=VPC_PEERING \
    --prefix-length=16 \
    --description="peering range" \
    --network=default;

gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --ranges=google-managed-services-default \
    --network=default \
    --project=$1;

gcloud beta sql instances create \
    --zone us-central1-c \
    --database-version POSTGRES_11 \
    --memory 7680MiB \
    --cpu 2 \
    --storage-auto-increase \
    --network=projects/$1/global/networks/default \
    --backup-start-time 08:00 edfi-ods-db;

sleep 5;

gcloud sql databases create 'EdFi_Admin' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Security' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_2023' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_2022' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_2021' --instance=edfi-ods-db;
