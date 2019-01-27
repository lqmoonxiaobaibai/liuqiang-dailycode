#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-26
#FileName:                array.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

declare -A name

name[1]='aaa'
name["s"]=123

for i in ${name[*]};do
     echo $i
done


declare -a name1
name1=("a" "b")
length=${#name1[*]}

for i in $(seq 0 $[$length-1]);do
  echo ${name1[$i]}                                                                                          
done
