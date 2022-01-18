# Ed-Fi v3.4 to v5.1

Prerequisite: .NET Core 3.1 SDK

* Take API and Admin App offline
* Upgrade databases
* Deploy Ed-Fi API and Admin App

```bash

# connect via cloud sql proxy
cloud_sql_proxy -instances=<INSTANCE_CONNECTION_NAME>=tcp:5432;

# add edfi nuget source
dotnet nuget add source https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_packaging/EdFi/nuget/v3/index.json;

# download migration utility
dotnet tool install EdFi.Suite3.Ods.Utilities.Migration --version 2.1.0 --tool-path .;

# run migration on ODS databases
./EdFi.Ods.Utilities.Migration --Database "host=localhost;port=5432;username=postgres;password=XXXXXX;database=EdFi_Ods_2022;" --Engine "PostgreSQL";

# download db deploy tool
dotnet tool install EdFi.Suite3.Db.Deploy --version 2.1 --tool-path .;

# download db scripts
wget -O edfi.databases.nupkg  https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.RestApi.Databases/versions/5.1.0/content;
unzip edfi.databases.nupkg -d edfi.databases/;

# upgrade EdFi_Admin
./EdFi.Db.Deploy deploy \
    --database "Admin" \
    --engine "PostgreSQL" \
    --connectionString "host=localhost;port=5432;username=postgres;password=XXXXXX;database=EdFi_Admin;" \
    --filePaths "./edfi.databases/Ed-Fi-ODS,./edfi.databases/Ed-Fi-ODS-Implementation";

# upgrade EdFi_Security
./EdFi.Db.Deploy deploy \
    --database "Security" \
    --engine "PostgreSQL" \
    --connectionString "host=localhost;port=5432;username=postgres;password=XXXXXX;database=EdFi_Security;" \
    --filePaths "./edfi.databases/Ed-Fi-ODS,./edfi.databases/Ed-Fi-ODS-Implementation";

```
