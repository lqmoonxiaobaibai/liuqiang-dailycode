#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-12-28
#FileName:                php-fpm.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
#需要提前申请企业钉钉机器人获取Url接口，写入到变量Dingding_Url中
#定义函数：发送钉钉消息
function SendMessageToDingding(){ 
    Dingding_Url="https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
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
  Body="WebServerHost_Php_Service_Down"
  count=0
  
  $path1 = xxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/phpstatuslog/fpmnormal.log
  $path2 = xxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/phpstatuslog/fpmstart.log
  $path3 = xxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/phpstatuslog/fpmerror.log

  #达到阈值报警时、连续报警三次发送到钉钉机器人
  pidof php-fpm > /dev/null 2>&1 
  processstatus=`echo $?`
  if [ "$processstatus" -eq 0 ];then
          time=`date +"%F %T"`
          echo "fpm service is normal At $time" >> $path1
  else
         service php-fpm start > /dev/null 2>&1 
	 restartstatus=`echo $?`
         if [ "$restartstatus" -eq 0 ];then
             time=`date +"%F %T"`
	     echo "fpm service start success At $time" >> $path2
	 else
	     time=`date +"%F %T"`
	     echo "fpm service start failed At $time" >>  $path3
	     wall "phpfpm service start is failed! phpfpm service is off! please tell administrator right now!!!"
	     while [ $count -lt 3 ];do
	           SendMessageToDingding $Subject $Body  > /dev/null 2>&1
	           let count++
 	     done
	 fi
   fi

