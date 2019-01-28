#!/bin/bash

file1=/tmp/iptablescount1
file2=/tmp/iptablescount2
file3=/tmp/iptableschangefile

if [ ! -f "$file1" ];then
  iptables -L -n|md5sum|awk '{print $1}' > $file1
  exit 1

else

  iptables -L -n|md5sum|awk '{print $1}' > $file2

  difffile=`diff $file1 $file2 | wc -l`

  if [ $difffile -eq 0 ];then
     echo "iptables is ok!"
     \rm -f $file2

  else

     echo "iptables is changed!"
     diff $file1 $file2 > $file3
  fi
fi
