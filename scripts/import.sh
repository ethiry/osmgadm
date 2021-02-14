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

osmosis --read-pbf $PBF --tag-filter accept-relations "boundary=administrative" --used-way --used-node --write-pgsql user=$DB_USER database=$DB_NAME password=$DB_PW host=$DB_HOST:$DB_PORT 

# sh scripts/generatepolygons.sh  
