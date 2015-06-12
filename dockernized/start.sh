#!/bin/bash
docker run  -d -t  --name "as" -h "as"    trumanz/ubuntu12.04:dev  /bin/bash
docker exec -t -i  as  wget http://public-repo-1.hortonworks.com/ambari/ubuntu12/2.x/updates/2.0.1/ambari.list
docker exec -t -i  as  mv  ambari.list  /etc/apt/sources.list.d/
docker exec -t -i  as  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD
docker exec -t -i  as  apt-get  update
docker exec -t -i  as  apt-get  install ambari-server
docker exec -t -i  as  /etc/init.d/ssh restart


docker run  -d -t  --name "ag1" -h "ag1"    trumanz/ubuntu12.04:dev  /bin/bash
docker exec -t -i  ag1  /etc/init.d/ssh restart

docker inspect -f  '{{.NetworkSettings.IPAddress}}' as
docker inspect -f  '{{.NetworkSettings.IPAddress}}' ag1
