#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-12-28
#FileName:                mysql.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
#需要提前申请企业钉钉机器人获取Url接口，写入到变量Dingding_Url中
#定义函数：发送钉钉消息
function SendMessageToDingding(){ 
    Dingding_Url="https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
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
  Body="DBServerHost_Mariadb_Service_Down"
  count=0
  $path1 =  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/mysqlstatuslog/mysqlnormal.log
  $path2 =  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/mysqlstatuslog/mysqlstart.log
  $path3 =  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/mysqlstatuslog/mysqlerror.log

#达到阈值报警时、连续报警三次发送到钉钉机器人
  pidof mysqld &> /dev/null
  processstatus=`echo $?`
  if [ "$processstatus" -eq 0 ];then
          time=`date +"%F %T"`
          echo "mysqld service is normal At $time" >> $path1
  else
         service mysqld start &> /dev/null
	 restartstatus=`echo $?`
         if [ "$restartstatus" -eq 0 ];then
             time=`date +"%F %T"`
	     echo "mysqld service start  success At $time" >> $path2
	 else
	     time=`date +"%F %T"`
	     echo "mysqld service start failed At $time" >> $path3
	     wall "mysqld service start is failed! mysqld service is off! please tell administrator right now!!!"
	     while [ $count -lt 3 ];do
	           SendMessageToDingding $Subject $Body  > /dev/null 2>&1
	           let count++
	     done
	 fi
   fi

