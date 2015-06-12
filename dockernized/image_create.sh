#!/bin/bash
docker rmi  trumanz/ambari:dev
docker build   -t  trumanz/ambari:dev  ./
