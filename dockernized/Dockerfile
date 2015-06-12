From trumanz/ubuntu12.04:dev

maintainer  Truman Zhou <truman.ck.zhou@gmail.com>

RUN wget http://public-repo-1.hortonworks.com/ambari/ubuntu12/2.x/updates/2.0.1/ambari.list && mv ambari.list  /etc/apt/sources.list.d/ && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD &&  apt-get  update &&  apt-get  install -y ambari-server ambari-agent && rm /root/.ssh/*   
COPY ssh/*  /root/.ssh/

