cypher_file=$1
errorMessage="Please set the parameter"

if [[ "$1" == "" ]]; then
    echo $errorMessage
    exit
else
    filename=$1

    SUB='cypher'
    if [[ "$1" != *"$SUB"* ]]; then
       echo "It's not a cypher file."
       exit
    fi
fi

neopath="~/neo4j-community-3.3.5/bin"

#deleting the nodes
beforeNodeDeletion=time $neopath/cypher-shell "match(n:) return count(n)"
echo $beforeNodeDeletion
time $neopath/cypher-shell "match(n:Infosys) detach delete n"
afterNodeDeletion=time $neopath/cypher-shell "match(n:) return count(n)"
echo $afterNodeDeletion


#import cypher-shell
cat <backup path>/$filename | $neopath/cypher-shell

afterNodeRestore=time $neopath/cypher-shell "match(n:) return count(n)"
echo $afterNodeRestore

