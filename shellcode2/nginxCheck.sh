#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-12-28
#FileName:                nginxCheck.sh
#Description:             The test script
#Copyright(C):            2018 All rights reserved
#******************************************************************
#需要提前申请企业钉钉机器人获取Url接口，写入到变量Dingding_Url中
#定义函数：发送钉钉消息
function SendMessageToDingding(){ 
    Dingding_Url="https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
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
  Body="WebServerHost_Nginx_Service_Down"
  count=0
  
  $path1 = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/nginxstatuslog/nginxnormal.log
  $path2 = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/nginxstatuslog/nginxstart.log
  $path3 = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/nginxstatuslog/nginxerror.log
  
  #达到阈值报警时、连续报警三次发送到钉钉机器人
  pidof nginx &> /dev/null
  processstatus=`echo $?`
  if [ "$processstatus" -eq 0 ];then
          time=`date +"%F %T"`
          echo "nginx service is normal At $time" >> $path1
  else
         nginx &> /dev/null
         restartstatus=`echo $?`
         if [ "$restartstatus" -eq 0 ];then
             time=`date +"%F %T"`
             echo "nginx service start success At $time" >> $path2
         else
             time=`date +"%F %T"`
             echo "nginx service start failed At $time" >> $path3
             wall "nginx service start is failed! nginx service is off! please tell administrator right now!!
!"           
             while [ $count -lt 3 ];do
             SendMessageToDingding $Subject $Body  > /dev/null 2>&1
             let count++
             done
         fi
  fi
