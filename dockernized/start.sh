#!/bin/bash

AGENT_NUM=5



docker run  -d -t  --name "as" -h "as"    trumanz/ambari:dev   /bin/bash
docker exec -t -i  as  /etc/init.d/ssh restart


docker run  -d -t  --name "ag1" -h "ag1"  trumanz/ambari:dev     /bin/bash
docker exec -t -i  ag1  sed -i  "s/hostname=.*/hostname=as/g" /etc/ambari-agent/conf/ambari-agent.ini
docker exec -t -i  ag1  /etc/init.d/ssh restart

ASIP=$(docker inspect -f  '{{.NetworkSettings.IPAddress}}' as)
AG1IP=$(docker inspect -f  '{{.NetworkSettings.IPAddress}}' ag1)

docker exec -t -i  as   bash -c  "echo '$AG1IP  ag1'  >>   /etc/hosts"
docker exec -t -i  ag1  bash -c  "echo '$ASIP  as'  >>   /etc/hosts "

docker exec -t -i  as  bash -c "cd /usr/lib/ambari-server/web/javascripts/ && gunzip app.js.gz  && sed -i.bak \"s@].contains(mPoint@, '/etc/resolv.conf', '/etc/hostname', '/etc/hosts'].contains(mPoint@g\" /usr/lib/ambari-server/web/javascripts/app.js  && cd /usr/lib/ambari-server/web/javascripts/ && gzip -9 app.js"

docker exec -t -i  as   ambari-server setup -s  -j /usr/lib/jvm/java-7-openjdk-amd64/  
docker exec -t -i  as   ambari-server start 

echo "Try http://$ASIP:8080 with admin:admin on firefox" 
