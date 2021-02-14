if [ ! -f "$1" ]
then
    if [ ! -f config.cfg ]
    then
        echo "Could not found config file!"
        echo "usage: $0 path_to_config"
        exit
    else
        . ./config.cfg
    fi
else
    . $1
fi

for table in actions log nodes relation_members relations schema_info tree_world users way_nodes ways
do
    psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -c "truncate table $table"
done
