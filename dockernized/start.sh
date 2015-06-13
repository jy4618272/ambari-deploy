#!/bin/bash

CONTAINERS="
as
ag1
ag2
ag3"

for c in $CONTAINERS; do 
   echo $c
   docker rm -f $c
   docker run  -d -t  --name "$c" -h "$c"    trumanz/ambari:dev   /bin/bash
   docker exec -t -i  $c  /etc/init.d/ssh restart
done

for c in $CONTAINERS; do 
    ip=$(docker inspect -f  '{{.NetworkSettings.IPAddress}}' $c)
    echo "$c : $ip"   
    for c2 in $CONTAINERS; do 
        docker exec -t -i  $c2   bash -c  "echo '$ip  $c'  >>   /etc/hosts"
    done
done
    

docker exec -t -i  as  bash -c "cd /usr/lib/ambari-server/web/javascripts/ && gunzip app.js.gz  && sed -i.bak \"s@].contains(mPoint@, '/etc/resolv.conf', '/etc/hostname', '/etc/hosts'].contains(mPoint@g\" /usr/lib/ambari-server/web/javascripts/app.js  && cd /usr/lib/ambari-server/web/javascripts/ && gzip -9 app.js"

docker exec -t -i  as   ambari-server setup -s  -j /usr/lib/jvm/java-7-openjdk-amd64/  
docker exec -t -i  as   bash -c "ambari-server start"

echo "Try http://$ASIP:8080 with admin:admin on firefox" 
