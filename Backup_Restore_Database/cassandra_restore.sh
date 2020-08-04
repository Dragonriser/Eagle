#!/bin/bash
# Description : Restore Keyspace SCHEMA and SNAPSHOT

_NODETOOL=$(which nodetool)
_BACKUP_DIR=$(ls -td -- <backups> | head -n 1)  
_KEYSPACE_PATH=$_BACKUP_DIR/Keyspace_name_schema.cql
_BACKUP_SCHEMA_DIR="$_BACKUP_DIR/SCHEMA"
_BACKUP_SNAPSHOTS_DIR="$_BACKUP_DIR/SNAPSHOTS"

#echo $_BACKUP_DIR
#echo $_BACKUP_SCHEMA_DIR
#echo $_KEYSPACE_PATH
echo "Initiating schema"
for i in $(cat $_KEYSPACE_PATH)
do
if [ -d $_BACKUP_SCHEMA_DIR/$i ]
then
echo $_BACKUP_SCHEMA_DIR/$i
cqlsh -f $_BACKUP_SCHEMA_DIR/$i/*
else
echo "$i schema does not exist"
fi
done
echo "end schema"

echo "restore database start"
###### restore all data
cd $_BACKUP_SNAPSHOTS_DIR
for k in *; do
    if [ -d "$k" ]; then
        cd /var/lib/cassandra/data/$k
        ls -td -- * | tail -n 1  >> $_BACKUP_DIR/src.txt
        ls -td -- * | head -n 1 >> $_BACKUP_DIR/dest.txt
        for s in $(cat $_BACKUP_DIR/src.txt)
         do
          cd /var/lib/cassandra/data/$k/$s/snapshots
            ls -td -- * | tail -n 2 | head -n 1 >> $_BACKUP_DIR/src1.txt
                for s1 in $(cat $_BACKUP_DIR/src1.txt)
                 do
                  cd /var/lib/cassandra/data/$k
                   for d in $(cat $_BACKUP_DIR/dest.txt)
                    do
                        echo "<cassandra-data path>/$k/$s/snapshots/$s1"
                        echo "<cassandra-data path>/$k/$d"
                        cp -arv  <cassandra-datapath>/$k/$s/snapshots/$s1/*  <cassandra-data path>/$k/$d/
                   done
                 done
         done


        rm $_BACKUP_DIR/src.txt
        rm $_BACKUP_DIR/src1.txt
        rm $_BACKUP_DIR/dest.txt
        chmod -R 777  <cassandra-data path>/$k
        cd $_BACKUP_SNAPSHOTS_DIR/$k
        ls -td -- * | head -n 1 | cut -f1 -d"-">>$_BACKUP_DIR/tables.txt
        for t in $(cat $_BACKUP_DIR/tables.txt)
               do
                       sudo $_NODETOOL refresh -- $k $t
                done
        cd $_BACKUP_SNAPSHOTS_DIR
        rm $_BACKUP_DIR/tables.txt
    fi
done
echo "restore database end"
