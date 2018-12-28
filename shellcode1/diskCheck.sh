#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-11-05
#FileName:                diskCheck.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
$path1 = /xxx/scriptPath/spacechecklog/systemdiskspaceerror.log
$path2 = /xxx/scriptPath/spacechecklog/systemdiskspacenormal.log
$path3 = /xxx/scriptPath/spacechecklog/appDiskspaceerror.log
$path4 = /xxx/scriptPath/spacechecklog/appDiskspacenormal.log
$path5 = /xxx/scriptPath/spacechecklog0/dataDiskspaceerror.log
$path6 = /xxx/scriptPath/spacechecklog/dataDiskspacenormal.log


#取出系统盘各个分区的使用情况到临时文件中
declare -A systemDisk

df -h|grep "/dev/vda" > /tmp/system12345678900987654321.log
while read line;do
     index=`echo $line|cut -d " " -f1`
     space=`echo $line|sed -r 's/.*[[:space:]]+([0-9]+)%.*/\1/g'`
     systemDisk["$index"]=$space
done < /tmp/system12345678900987654321.log

#检测系统盘各个分区的使用状态
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

\rm -rf /tmp/system12345678900987654321.log


#取出业务盘各个分区的使用情况到临时文件中

declare -A appDisk
df -h|grep "/data2/boxx" > /tmp/bona12345678900987654321.log
while read line1;do
     index1=`echo $line1|tr -d " "|cut -d "%" -f2`
     space1=`echo $line1|sed -r 's/.*[[:space:]]+([0-9]+)%.*/\1/g'`
     appDisk["$index1"]=$space1
done < /tmp/bona12345678900987654321.log

#检查业务盘各个分区的使用状态

for key1 in ${!appDisk[*]}; do
 if [ "${appDisk[$key1]}"  -gt 80 ];then
    time=`date +"%F %T"`
    echo "$key1 disk space expand 80%!!!  please tell administrator right now!!! At $time!!!" >> $path3
    wall "$key1 disk space expand 80%!!!  please tell administrator right now!!!"
 else
    time=`date +"%F %T"`
    echo "$key1  disk  space are normal!!! At $time!!!" >> $path4
 fi
done

\rm -rf /tmp/bona12345678900987654321.log



#取出数据盘各个分区的使用情况到临时文件中

declare -A dataDisk
df -h|grep "/data1/mysql" > /tmp/mysql12345678900987654321.log
while read line2;do
     index2=`echo $line2|tr -d " "|cut -d "%" -f2`
     space2=`echo $line2|sed -r 's/.*[[:space:]]+([0-9]+)%.*/\1/g'`
     dataDisk["$index2"]=$space2
done < /tmp/mysql12345678900987654321.log


#检查数据盘各个分区的使用状态

for key2 in ${!dataDisk[*]}; do
 if [ "${dataDisk[$key2]}"  -gt 1 ];then
    time=`date +"%F %T"`
    echo "$key2 disk space expand 80%!!!  please tell administrator right now!!! At $time!!!" >>  $path5
    wall "$key2 disk space expand 80%!!!  please tell administrator right now!!!"
 else
    time=`date +"%F %T"`
    echo "$key2 disk  space are normal!!! At $time!!!" >>  $path6
  fi
done

\rm -rf /tmp/mysql12345678900987654321.log
