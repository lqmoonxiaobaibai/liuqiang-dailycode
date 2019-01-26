#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-25
#FileName:                test4.sh
#Description:             The test script
#Copyright(C):             2019 All rights reserved
#******************************************************************

declare -A systemDisk

df|awk -F% '/^\/dev\/sd*/{print $1}'|awk '{print $1,$5}' > /tmp/test.txt
while read disk space;do
        systemDisk["$disk"]=$space
done <  /tmp/test.txt
        
#echo ${system[*]} 
#echo ${!system[*]}
#echo ${#system[*]}

#for key in ${!system[*]};do
#       echo "$key,${system[$key]}"
#done


for key in ${!systemDisk[*]}; do
 if [ "${systemDisk[$key]}"  -gt 80 ];then 
        time=`date +"%F %T"`
        echo "$key disk space expand 80%!!!  please tell administrator right now!!! At $time!!!" >> $path1
        wall "$key disk space expand 80%!!!  please tell administrator right now!!!"
 else 
        time=`date +"%F %T"`                                                                                                       
        echo "$key  disk  space are normal!!! At $time!!!" >> $path2
 fi            
done

\rm -rf /tmp/test.txt
