#!/bin/sh

  plotfile=$(find /mnt/tmp -type f -name "*.plot" |sort -n|head -1)
  if [ -z $plotfile ]; then
  echo "nofile, sleep 10m;"
  sleep 10m
  else
  tmpfile=$(dirname $plotfile)
  echo "$plotfile"
  rsync $plotfile /mnt/dst
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "rsync:failed: $ret; sleep 5m"
    sleep 5m;
  else
    mkdir -p ${tmpfile}/empty ${tmpfile}/rmfile
    mv $plotfile ${tmpfile}/rmfile
    rsync --delete-before -a -H --stats ${tmpfile}/empty/ ${tmpfile}/rmfile/
  fi
  fi
