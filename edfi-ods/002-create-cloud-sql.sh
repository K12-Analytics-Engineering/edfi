gcloud sql instances create \
--zone us-central1-c \
--database-version POSTGRES_11 \
--memory 7680MiB \
--cpu 2 \
--storage-auto-increase \
--backup-start-time 08:00 edfi-ods-db;

sleep 5;

gcloud sql databases create 'EdFi_Admin_Hogwarts' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Security_Hogwarts' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_Hogwarts_2022' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_Hogwarts_2021' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_Hogwarts_2020' --instance=edfi-ods-db;

gcloud sql databases create 'EdFi_Admin_Ilvermorny' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Security_Ilvermorny' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_Ilvermorny_2022' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_Ilvermorny_2021' --instance=edfi-ods-db;
gcloud sql databases create 'EdFi_Ods_Ilvermorny_2020' --instance=edfi-ods-db;
