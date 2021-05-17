#!/bin/sh
plotfile=$(find /mnt/dst -type f -name "*.plot" |sort -n|head -1)
if [ -z $plotfile ]; then
echo "nofile, sleep 10m;"
sleep 10m
else
echo $plotfile
rsync --bwlimit=150000 $plotfile ubuntu@chia:/mnt/dst/001
ret=$?
if [ $ret -ne 0 ]; then
  echo "rsync:failed: $ret"
else
  mkdir -p empty rmfile
  mv $plotfile ./rmfile
  rsync --delete-before -a -H --stats ./empty/ ./rmfile/
fi
fi
