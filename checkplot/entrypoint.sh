#!/bin/sh

APPNAME=check
usage() {
  if [ $# -eq 0 ]; then
    echo ""
    echo "${APPNAME}"
    echo ""
    echo "Usage:"
    echo ""
    printf "%s\n" "  ${APPNAME} [path]"
    exit 1
  fi
}

check_run(){
  [ "$#" -eq 1 ] || fatal "check faild: path."
  local path="$1"

  plotfilelist=$(find $path -not -empty -type f -name "*.plot" |sort -n)

  errfile=""
  errno=0
  for plotfile in $plotfilelist; do
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
      else
        echo "Invalid plot file format"
        errfile=$errfile"\n"$plotfile
        errno=$((errno+1))
      fi
    else
      echo "Invalid plot header magic ;"
      # mkdir -p ${tmpfile}/z
      # mv $plotfile ${tmpfile}/z
      errfile=$errfile"\n"$plotfile
      errno=$((errno+1))
    fi
  done

  echo "$errfile"
  echo "tatol err file: $errno"

}
do_check() {
  [ "$#" -eq 1 ] || fatal "faild: path."
  local path="$1"
  check_run "${path}"
}

[ "$#" -ge 2 ] || {
  usage
  exit 1
}
subcommand="$1"
shift

case "$subcommand" in
check)
  do_check "$@"
  ;;
*)
  fatal "Unknown subcommand $subcommand"
  ;;
esac
