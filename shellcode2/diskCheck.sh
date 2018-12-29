#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-12-28
#FileName:                diskCheck.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
#需要提前申请企业钉钉机器人获取Url接口，写入到变量Dingding_Url中
#定义函数：发送钉钉消息
function SendMessageToDingding(){ 
    Dingding_Url="https://xxxxxxxxxxxxxxxxxx" 
    curl "${Dingding_Url}" -H 'Content-Type: application/json' -d "
    {
        \"actionCard\": {
            \"title\": \"$1\", 
            \"text\": \"`date +"%F %T"` $2\",
            \"hideAvatar\": \"0\", 
            \"btnOrientation\": \"0\", 
            \"btns\": [
                {
                    \"title\": \"$1\", 
                    \"actionURL\": \"\"
                }
            ]
        }, 
        \"msgtype\": \"actionCard\"
    }"
} 

  Subject="Alarm_News" 
  Body1="WebServerHost_SystemDiskSpace_Expand"
  Body2="WebServerHost_AppDiskSpace_Expand"
  count1=0
  count2=0

$path1 =  xxxxxxxxxxxxxxxxxx/scriptPath/spacechecklog/systemdiskspaceerror.log
$path2 =  xxxxxxxxxxxxxxxxxx/spacechecklog/systemdiskspacenormal.log
$path3 =  xxxxxxxxxxxxxxxxxx/scriptPath/spacechecklog/appDiskspaceerror.log
$path4 =  xxxxxxxxxxxxxxxxxx/scriptPath/spacechecklog/appDiskspacenormal.log

#达到阈值报警时、连续报警三次发送到钉钉机器人
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
       while [ $count1 -lt 3 ];do
             SendMessageToDingding $Subject $Body1  > /dev/null 2>&1
	     let count1++
       done
 else 
    time=`date +"%F %T"`
    echo "$key  disk  space are normal!!! At $time!!!" >> $path2
 fi            
done

\rm -rf /tmp/system12345678900987654321.log


#取出业务盘各个分区的使用情况到临时文件中

declare -A appDisk
df -h|grep "/data/bona" > /tmp/bona12345678900987654321.log
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
    while [ $count2 -lt 3 ];do
          SendMessageToDingding $Subject $Body2  > /dev/null 2>&1
          let count2++
    done
 else
    time=`date +"%F %T"`
    echo "$key1  disk  space are normal!!! At $time!!!" >> $path4
 fi
done

\rm -rf /tmp/bona12345678900987654321.log


