#!/bin/bash

mydir=$(cd `dirname $(realpath "${BASH_SOURCE[0]}")` && pwd)

root_passwd=root

name='docker.mysql'
image='mysql:latest'
container_hostname='mysql-docker.dev'
hostsfile=/etc/hosts

# cleanup if this container does exist but stopped.
container_running=$(docker ps -a --filter "name=$name" --filter "status=running" --format "{{.ID}}")
if [ "$container_running" != "" ]; then
  echo "Container already running"
else
  container_stopped=$(docker ps -a --filter "name=$name" --filter "status=exited" --format "{{.ID}}")
  if [ "$container_stopped" != "" ]; then
    docker start "$container_stopped"
  else
    cust_config_folder="${mydir}/../mysql"
    docker run --name "$name" -v ${cust_config_folder}:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=$root_passwd -d "$image"
  fi
fi

ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' ${name})
"${mydir}"/d7-add-host.sh ${ip} ${container_hostname}
if [ $? -ne 0 ]; then
  container_hostname=${ip}
fi

echo " :MYSQL:  Access me on ${container_hostname}"":3306"
echo " :MYSQL:  MySQL root password: $root_passwd"
