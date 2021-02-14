#!/bin/sh

#ATTENTION!!!! THIS SCRIPT WILL DELETE YOUR PGSQL DB FOREVER!!!!
#READ CAREFULLY!

#this script is intended to be run by the pgsql user, NOT ROOT!!!!

# this script will (re-) create a complete new postgrestql DB
# it will create the db, create a user, init postgis and
# init all osmosis schema creation scripts (snapshot variant)
# todo: automatically add escape_string_warning = off to postgresql.conf

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

OSMOSISHOME=/usr/local/Cellar/osmosis/0.45/libexec

#DBLOCATION=/home/manu/db/oos


#/usr/local/etc/rc.d/postgresql stop

#rm -rf $DBLOCATION/*
#mkdir -p $DBLOCATION


#initdb -E UTF8 -D $DBLOCATION
#/usr/local/etc/rc.d/postgresql start
#createdb -E UTF8 $DBNAME
#createuser -s $DBUSERNAME
# as superadmin :
# grant all to $DBUSERNAME
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -c "create extension postgis;"
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -c "create extension hstore;"

#psql -d $DBNAME -f /usr/local/share/postgis/contrib/postgis-1.5/postgis.sql
#psql -d $DBNAME -f /usr/local/share/postgis/contrib/postgis-1.5/spatial_ref_sys.sql

psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -f $OSMOSISHOME/script/pgsnapshot_schema_0.6.sql
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -f $OSMOSISHOME/script/pgsnapshot_schema_0.6_action.sql
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -f $OSMOSISHOME/script/pgsnapshot_schema_0.6_bbox.sql
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -f $OSMOSISHOME/script/pgsnapshot_schema_0.6_linestring.sql

psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -f ../sql/inittreeworld.sql
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -f ../sql/createtree.sql
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -f ../sql/iso3166-1.sql
psql -h $DB_HOST -d $DB_NAME -p $DB_PORT -U $DB_USER -f ../sql/iso3166-2.sql

#echo "alter role $DBUSERNAME password '$DBUSERPASSWORD';" | psql -d $DBNAME
#echo "ALTER TABLE geometry_columns OWNER TO $DBUSERNAME; ALTER TABLE spatial_ref_sys OWNER TO $DBUSERNAME;" | psql -d $DBNAME
