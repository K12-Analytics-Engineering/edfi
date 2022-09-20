export PGPASSWORD=$1;

for FILE in `LANG=C ls artifacts/ed-fi-ods-admin-scripts/PgSql/* | sort -V`
    do
        psql -h localhost -U postgres 'EdFi_Admin' < $FILE 
    done
