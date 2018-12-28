#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-11-05
#FileName:                iptablesCheck.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
$path = xxxxx/iptablesblacklistlog
ss -nt|grep "ESTAB"|awk '{print $5}'|awk -F: '{print $1}'|grep -vE '(172.21|127.0|169.254)'|awk '{IP[$1]++}END{for(i in IP){if(IP[i]>500) print i}}'|while read ip;
do
    ipset add blacklist  $ip > /dev/null 2>&1 
    state=`echo $?`
    if [  "$state" -eq 0  ];then
       echo "At time:$(date +'%F %T') $ip expand 500 links and has already rejected one hour!!!"  >> xxxx/iptable.log 
      else
             continue
     fi
done







