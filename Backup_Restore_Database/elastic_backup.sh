################################### Added the DB backfile size ###############################
SNAPSHOT=`date +%Y%m%d-%H%M%S`
start_mark=$(date +%s)
start_time=$(date +%G-%m-%d'T'%H-%m  -d "1 days ago")

path=<path where you want to keep the backup>
FILENAME=$path/$SNAPSHOT

curl -XPUT "http://<ES IP>:<ES Port>/_snapshot/backup/$SNAPSHOT?wait_for_completion=true"
o1=$?
cd <es repo>
tar -zcvf $SNAPSHOT.tar.gz *  
o2=1

if [ $o1 -eq 0 ] && [ $o2 -eq 0 ]
then
job_status="1"
else
job_status="0"
fi
time_taken=$(($(date +%s)-$start_mark))

