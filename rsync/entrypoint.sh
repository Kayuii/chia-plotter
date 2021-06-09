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
  # find -not -empty -type f -name "*.plot" -ls |sort -rk7|awk '{printf $11"\n"}'|head -1
  plotfile=$(find /mnt/dst -not -empty -type f -name "*.plot" |sort -n|head -1)
  if [ -z $plotfile ]; then
    echo "nofile, sleep 10m;"
    sleep 10m;
  else
    tmpfile=$(dirname $plotfile)
    echo "$plotfile"
    echo "check header magic"
    # "Proof of Space Plot" UTF-8
    magic="50726F6F66206F6620537061636520506C6F74"
    # hexdump -n 19 -e '19/1 "%02X ""\t"" "' -e '19/1 "%c""\n"'
    prefix="$(hexdump -n 19 -e '19/1 "%02X"' $plotfile)"
    # -z $(echo "$I"|sed "/$N$A/d")
    if [ "$magic" = "$prefix" ]; then
      echo "plotID: $(hexdump -s 19 -n 32 -e '32/1 "%02X"' $plotfile)"
      echo "K: $(hexdump -s 51 -n 1 -e '1/1 "%d"' $plotfile)"
      fmt_desc_len=$(hexdump -s 52 -n 2 -e '2/1 "%02X"' $plotfile)
      if [ $((0x$fmt_desc_len)) -ne 0 ]; then
        echo "fmt_desc: $(hexdump -s 54 -n $((0x$fmt_desc_len)) -e '1/1 "%02X"' $plotfile)"
        memo_len=$(hexdump -s $((0x$fmt_desc_len + 54)) -n 2 -e '2/1 "%02X"' $plotfile)
        echo "memo: $(hexdump -s $((0x$fmt_desc_len + 56)) -n $((0x$memo_len)) -e '1/1 "%02X"' $plotfile)"
        if [ $((0x$memo_len)) -eq 128 ]; then
            # 48+48+32
            echo "ppk: $(hexdump -s $((0x$fmt_desc_len + 56)) -n 48 -e '1/1 "%02X"' $plotfile)"
            echo "fpk: $(hexdump -s $((0x$fmt_desc_len + 56+48)) -n 48 -e '1/1 "%02X"' $plotfile)"
            echo "sk : $(hexdump -s $((0x$fmt_desc_len + 56+48+48)) -n 32 -e '1/1 "%02X"' $plotfile)"
        fi
        if [ $((0x$memo_len)) -eq 112 ]; then
            # 32+48+32
            echo "ppk: $(hexdump -s $((0x$fmt_desc_len + 56)) -n 32 -e '1/1 "%02X"' $plotfile)"
            echo "fpk: $(hexdump -s $((0x$fmt_desc_len + 56+32)) -n 48 -e '1/1 "%02X"' $plotfile)"
            echo "sk : $(hexdump -s $((0x$fmt_desc_len + 56+32+48)) -n 32 -e '1/1 "%02X"' $plotfile)"
        fi

        rsync --bwlimit=200000 --whole-file $plotfile ${host}:${path}
        ret=$?
        sleep 10;
        if [ $ret -ne 0 ]; then
          echo "rsync:failed: $ret; sleep 5m"
          sleep 5m;
        else
          mkdir -p ${tmpfile}/empty ${tmpfile}/rmfile
          mv $plotfile ${tmpfile}/rmfile
          rsync --delete-before -a -H --stats ${tmpfile}/empty/ ${tmpfile}/rmfile/
        fi
      else
        echo "Invalid plot file format"
      fi
    else
    echo "Invalid plot header magic, move file to ./z ; and sleep 10 ;"
    mkdir -p ${tmpfile}/z
    mv $plotfile ${tmpfile}/z
    sleep 10
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
