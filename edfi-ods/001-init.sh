gcloud services enable sqladmin.googleapis.com;
gcloud services enable run.googleapis.com;
gcloud services enable cloudbuild.googleapis.com;
gcloud services enable secretmanager.googleapis.com;

wget -O artifacts/edfi.database.admin.nupkg  https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Admin.PostgreSQL/versions/5.3.153/content;
wget -O artifacts/edfi.database.security.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Security.PostgreSQL/versions/5.3.151/content;

wget -O artifacts/EdFi.Suite3.Ods.Minimal.Template.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/versions/5.3.232/content;
wget -O artifacts/EdFi.Suite3.Ods.Populated.Template.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/versions/5.3.247/content;

wget -O artifacts/EdFi.Suite3.ODS.AdminApp.Database.nupkg https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.ODS.AdminApp.Database/versions/2.3.1/content

unzip artifacts/edfi.database.admin.nupkg -d artifacts/edfi-ods-admin;
unzip artifacts/edfi.database.security.nupkg -d artifacts/edfi-ods-security;

unzip artifacts/EdFi.Suite3.Ods.Minimal.Template.nupkg -d artifacts/edfi-ods-minimal;
unzip artifacts/EdFi.Suite3.Ods.Populated.Template.nupkg -d artifacts/edfi-ods-populated;

unzip artifacts/EdFi.Suite3.ODS.AdminApp.Database.nupkg -d artifacts/ed-fi-ods-admin-scripts;

gcloud iam service-accounts create edfi-cloud-run;
