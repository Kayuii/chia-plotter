#! /bin/sh
plotfile=$(ls -l /mnt/dst/*.plot |awk 'NR==1{print $9}')
echo "x $plotfile"
