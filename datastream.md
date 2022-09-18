Create Cloud SQL flag: set **cloudsql.logical_decoding** to **On**

```sql
ALTER USER postgres WITH REPLICATION;

CREATE USER replication_user WITH REPLICATION IN ROLE cloudsqlsuperuser LOGIN PASSWORD 'Hn3n4h2123j';
GRANT SELECT ON ALL TABLES IN SCHEMA edfi TO replication_user;
GRANT USAGE ON SCHEMA edfi TO replication_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA edfi GRANT SELECT ON TABLES TO replication_user;

CREATE PUBLICATION edfi FOR ALL TABLES;
SELECT pg_create_logical_replication_slot('edfi_ods_2023', 'pgoutput');
```
