export PGPASSWORD=$1;
psql -h localhost -U postgres  'EdFi_Admin_Hogwarts' < artifacts/edfi-ods-admin/EdFi_Admin.sql;
psql -h localhost -U postgres  'EdFi_Security_Hogwarts' < artifacts/edfi-ods-security/EdFi_Security.sql;
psql -h localhost -U postgres  'EdFi_Ods_Hogwarts_2022' < artifacts/edfi-ods-populated/EdFi.Ods.Populated.Template.sql;
psql -h localhost -U postgres  'EdFi_Ods_Hogwarts_2021' < artifacts/edfi-ods-minimal/EdFi.Ods.Minimal.Template.sql;
psql -h localhost -U postgres  'EdFi_Ods_Hogwarts_2020' < artifacts/edfi-ods-minimal/EdFi.Ods.Minimal.Template.sql;

psql -h localhost -U postgres  'EdFi_Admin_Ilvermorny' < artifacts/edfi-ods-admin/EdFi_Admin.sql;
psql -h localhost -U postgres  'EdFi_Security_Ilvermorny' < artifacts/edfi-ods-security/EdFi_Security.sql;
psql -h localhost -U postgres  'EdFi_Ods_Ilvermorny_2022' < artifacts/edfi-ods-populated/EdFi.Ods.Populated.Template.sql;
psql -h localhost -U postgres  'EdFi_Ods_Ilvermorny_2021' < artifacts/edfi-ods-minimal/EdFi.Ods.Minimal.Template.sql;
psql -h localhost -U postgres  'EdFi_Ods_Ilvermorny_2020' < artifacts/edfi-ods-minimal/EdFi.Ods.Minimal.Template.sql;

for FILE in `LANG=C ls artifacts/ed-fi-ods-admin-scripts/PgSql/* | sort -V`
    do
        psql -h localhost -U postgres 'EdFi_Admin_Hogwarts' < $FILE;
        psql -h localhost -U postgres 'EdFi_Admin_Ilvermorny' < $FILE;
    done
