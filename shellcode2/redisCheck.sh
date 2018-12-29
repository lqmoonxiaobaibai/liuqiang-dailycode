#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-12-28
#FileName:                redis.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************

#需要提前申请企业钉钉机器人获取Url接口，写入到变量Dingding_Url中 
#定义函数：发送钉钉消息
function SendMessageToDingding(){ 
    Dingding_Url="https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
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
  Body="WebServerHost_Redis_Service_Down"
  count=0
  
  $path1 =  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/redisstatuslog/redisnormal.log
  $path2 =  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/redisstatuslog/redisstart.log
  $path3 =  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/redisstatuslog/rediserror.log

  #达到阈值报警时、连续报警三次发送到钉钉机器人
  pidof redis-server &> /dev/null
  processstatus=`echo $?`
  if [ "$processstatus" -eq 0 ];then
          time=`date +"%F %T"`
          echo "redis service is normal At $time" >>   $path1
  else
         service redis start &> /dev/null
	 restartstatus=`echo $?`
         if [ "$restartstatus" -eq 0 ];then
             time=`date +"%F %T"`
	     echo "redis service start success At $time" >>  $path2
	 else
	     time=`date +"%F %T"`
	     echo "redis service start failed At $time" >>   $path3
	     wall "redis service start is failed! redis service is off! please tell administrator right now!!!"
	     while [ $count -lt 3 ];do
	             SendMessageToDingding $Subject $Body  > /dev/null 2>&1
		     let count++
             done
	 fi
   fi

