. ../config.cfg

for table in actions iso3166_1 iso3166_2 log nodes relation_members relations schema_info testhstore tree_world users way_nodes ways             
do
    psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -c "alter table $table set schema $DB_SCHEMA"
    psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -c "grant all on table $table to $DB_USER"
done
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -c "grant all on schema $DB_SCHEMA to $DB_USER"