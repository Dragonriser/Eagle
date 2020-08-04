######################## Enable Elasticsearch DB backup log ########################
nodetool snapshot
start_mark=$(date +%s)
start_time=$(date +%G-%m-%d'T'%H-%m)
SNAPSHOT=`date +%Y%m%d-%H%M%S`
pg_dumpall -U postgres --file=""
o1=$?

FILESIZE=$(stat -c%s "$FILENAME" | awk '{print $1/1024/1024}')

if [ $o1 -eq 0 ] 
then
job_status="1"
else
job_status="0"
fi

