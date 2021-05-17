#!/bin/sh

APPNAME=rsync
usage() {
  if [ $# -eq 0 ]; then
    echo ""
    echo "${APPNAME}"
    echo ""
    echo "Usage:"
    echo ""
    printf "%s\n" "  ${APPNAME} <user:host> [path]"
    exit 1
  fi
}

rsync_run(){
  [ "$#" -eq 2 ] || fatal "rsync faild: hostname and path."
  local host="$1"
  local path="$2"
  plotfile=$(find /mnt/dst -type f -name "*.plot" |sort -n|head -1)
  if [ -z $plotfile ]; then
  echo "nofile, sleep 10m;"
  sleep 10m
  else
  tmpfile=$(dirname $plotfile)
  echo "$plotfile"
  rsync --bwlimit=150000 $plotfile ${host}:${path}
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "rsync:failed: $ret"
  else
    mkdir -p ${tmpfile}/empty ${tmpfile}/rmfile
    mv $plotfile ${tmpfile}/rmfile
    rsync --delete-before -a -H --stats ${tmpfile}/empty/ ${tmpfile}/rmfile/
  fi
  fi
}
do_rsync() {
  [ "$#" -eq 2 ] || fatal "faild: hostname and path."
  local host="$1"
  local path="$2"
  rsync_run "${host}" "${path}"
}


[ "$#" -ge 3 ] || {
  usage
  exit 1
}

subcommand="$1"
shift

case "$subcommand" in
rsync)
  do_rsync "$@"
  ;;
*)
  fatal "Unknown subcommand $subcommand"
  ;;
esac
