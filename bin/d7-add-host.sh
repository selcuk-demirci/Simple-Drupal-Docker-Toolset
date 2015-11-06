#!/bin/bash

hostsfile=/etc/hosts
ip=$1
hostname=$2

hostfile_entry="${ip} ${hostname} # generated by d7-docker"
if [ -w ${hostsfile} ]; then
  if [ "$(cat ${hostsfile} | grep ${hostname})" != "" ]; then
    cat ${hostsfile} | grep -v "\s${hostname}\s.*generated" > /tmp/.hostsfile
    cp /tmp/.hostsfile ${hostsfile}
  fi
  echo ${hostfile_entry} >> ${hostsfile}
else
  echo "============================================================================"
  echo "I cannot write your hostsfile, so cannot provide you with a nice hostname."
  echo "Do"
  echo "    chown root:$(whoami) /etc/hosts"
  echo "    chmod 770 /etc/hosts"
  echo " in order to fix this..."
  echo ""
  exit 1
fi
