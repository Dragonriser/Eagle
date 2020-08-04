#add/update in neo4j-community-3.3.5/conf/neo4j.conf
#apoc.export.file.enabled=true
#apoc.import.file.enabled=true


start_mark=$(date +%s)
start_time=$(date +%G-%m-%d'T'%H-%m)

now=$(date +"%m_%d_%Y")


#exports the whole database incl. indexes as cypher statements to the provided file
export exportAll="call apoc.export.cypher.all('<path where you want to keep the cypher file>/$now.cypher',{format:'cypher-shell'})"
echo $exportAllDefaultBatch
time /home/learning/neo4j-learning/neo4j-community-3.3.5/bin/cypher-shell  "$exportAll"
o1=$?


#zipped and password protected

#delete the file
rm $now.cypher

if [ $o1 -eq 0 ] 
then
job_status="1"
else
job_status="0"
fi

