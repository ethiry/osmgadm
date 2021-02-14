#!/bin/sh
set -x

if [ ! -f "$1" ]
then
    if [ ! -f config.cfg ]
    then
        echo "Could not found config.cfg file!"
        echo "usage: $0 path_to_config"
        exit
    else
        . ./config.cfg
    fi
else
    . $1
fi

#fetch http://planet.openstreetmap.org/pbf/planet-latest.osm.pbf
echo $PBF

#osmosis --truncate-pgsql user=$DB_USER database=$DB_NAME password=$DB_PW host=$DB_HOST
#osmosis --read-pbf $PBF --tf accept-relations "boundary=administrative" --used-way --used-node –-write-pgsql user=$DB_USER database=$DB_NAME password=$DB_PW host=$DB_HOST

osmosis --truncate-pgsql user=postgres database=osmgadm_test password=upward host=localhost:5433
osmosis --rx /dev/stdin --tf accept-relations "boundary=administrative" --used-way --used-node –-write-pgsql $OSMOSIS_CONN


bzcat ~/Downloads/GeoBazar/espagne_portugal.bz2 | osmosis --rx - enableDateParsing=no --tf accept-relations boundary=administrative --uw --un --wp $OSMOSIS_CONN

psql -h localhost -d osmgadm_full -p 5433 -U postgres -c 'create index tree_world_poly_idx on tree_world using gist(poly)'