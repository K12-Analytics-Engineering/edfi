# Ed-Fi v3.4 to v5.3

The guide below walks through the recommended way to update an Ed-Fi deployment to a later version of the data standard. This process can completed via Google Cloud Shell.

At this time it is recommended you delete the existing Ed-Fi API and Admin App Cloud Run services. The process for upgrading the `EdFi_Admin` and `EdFi_Security` databases is not as straightforward as upgrading the `EdFi_Ods` databases. This will mean creating new Ed-Fi API vendors and applications, and updating the source systems with new Ed-Fi API credentials.


## Download Ed-Fi Migration Utility

```bash
# add edfi nuget source
dotnet nuget add source https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_packaging/EdFi/nuget/v3/index.json;

# download migration utility
dotnet tool install EdFi.Suite3.Ods.Utilities.Migration --version 2.2.0 --tool-path .;

```

Ed-Fi's Migration Utility requires .NET Core 3.1 SDK. Cloud Shell has multiple versions of the .NET Core SDK installed. Create a `global.json` file and paste in the text below. That will tell `dotnet` to use version 3.1.

```
{
  "sdk": {
    "version": "3.1.417"
  }
}
```


## Upgrade ODS database(s)
```bash
# connect via cloud sql proxy
cloud_sql_proxy -instances=<INSTANCE_CONNECTION_NAME>=tcp:5432;

# run migration on ODS databases
./EdFi.Ods.Utilities.Migration --Database "host=localhost;port=5432;username=postgres;password=XXXXXX;database=EdFi_Ods_2022;" --Engine "PostgreSQL";

```

## Deploy Ed-Fi API and Admin App
The Ed-Fi API and Admin App can not be deployed using this tutorial.
<!-- # # download db deploy tool
# dotnet tool install EdFi.Suite3.Db.Deploy --version 2.1 --tool-path .;

# # download db scripts
# wget -O edfi.databases.nupkg  https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.RestApi.Databases/versions/5.1.0/content;
# unzip edfi.databases.nupkg -d edfi.databases/;

# # upgrade EdFi_Admin
# ./EdFi.Db.Deploy deploy \
#     --database "Admin" \
#     --engine "PostgreSQL" \
#     --connectionString "host=localhost;port=5432;username=postgres;password=XXXXXX;database=EdFi_Admin;" \
#     --filePaths "./edfi.databases/Ed-Fi-ODS,./edfi.databases/Ed-Fi-ODS-Implementation";

# # upgrade EdFi_Security
# ./EdFi.Db.Deploy deploy \
#     --database "Security" \
#     --engine "PostgreSQL" \
#     --connectionString "host=localhost;port=5432;username=postgres;password=XXXXXX;database=EdFi_Security;" \
#     --filePaths "./edfi.databases/Ed-Fi-ODS,./edfi.databases/Ed-Fi-ODS-Implementation";
 -->
