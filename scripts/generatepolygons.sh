#!/bin/sh

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

echo `date` " Started!"

pushd ../src/dist

for i in 2 3 4 5 6 7 8 9 10
do
    
  echo '---------------------------------------------'  
	echo `date` PROCESSING ADMINLEVEL $i

	time java -cp 'OSMGADM.jar:lib/*' osmgadm.TreeBuilder  --adminlevel=$i --dbname=$DB_NAME --dbhost=$DB_HOST --dbport=$DB_PORT --dbuser=$DB_USER --dbpw=$DB_PW --numthreads=$NUM_THREADS

	echo `date` DONE ADMINLEVEL $i
  echo '---------------------------------------------'  
done

popd

echo `date` " Finished!"
