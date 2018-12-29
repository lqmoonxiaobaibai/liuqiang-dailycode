#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-12-28
#FileName:                iptablesCheck.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
#需要提前申请企业钉钉机器人获取Url接口，写入到变量Dingding_Url中
#定义函数：发送钉钉消息
function SendMessageToDingding(){ 
    Dingding_Url="https://xxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
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
  Body="WebServerHost_Prevent_BlackIP"

$path =  xxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/iptablesblacklistlog/iptable.log 
ss -nt|grep "ESTAB"|awk '{print $5}'|awk -F: '{print $1}'|grep -vE '(172.21|127.0|169.254)'|awk '{IP[$1]++}END{for(i in IP){if(IP[i]>100) print i}}'|while read ip;
do
    ipset add blacklist  $ip > /dev/null 2>&1 
    state=`echo $?`
    if [  "$state" -eq 0  ];then
       echo "At time:$(date +'%F %T') $ip expand 100 links and has already rejected one hour!!!"  >> $path
       SendMessageToDingding $Subject $Body  > /dev/null 2>&1
    else
             continue
    fi
done
