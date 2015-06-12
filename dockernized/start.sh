#!/bin/bash
docker run  -d -t  --name "as" -h "as"    trumanz/ambari:dev   /bin/bash
docker exec -t -i  as  /etc/init.d/ssh restart


docker run  -d -t  --name "ag1" -h "ag1"  trumanz/ambari:dev     /bin/bash
docker exec -t -i  ag1  /etc/init.d/ssh restart


ASIP=$(docker inspect -f  '{{.NetworkSettings.IPAddress}}' as)
AG1IP=$(docker inspect -f  '{{.NetworkSettings.IPAddress}}' ag1)

docker exec -t -i  as   bash -c  "echo '$AG1IP  ag1'  >>   /etc/hosts"
docker exec -t -i  ag1  bash -c  "echo '$ASIP  as'  >>   /etc/hosts "

docker exec -t -i  as   ambari-server setup -s  -j /usr/lib/jvm/java-7-openjdk-amd64/  
docker exec -t -i  as   ambari-server start 

echo "Try http://$ASIP:8080 with admin:admin on firefox" 
