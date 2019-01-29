#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-30
#FileName:                alterMail.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

path1=/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/nginxstatuslog/nginxnormal.log
path2=/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/nginxstatuslog/nginxstart.log
path3=/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/scriptPath/nginxstatuslog/nginxerror.log

ethcard=ens33
Service="Nginx"
EMAIL=/tmp/email.txt

Date=`date +%F-%T`
IPAddr=`ifconfig $ethcard|awk 'NR==2{print $2}'`

emailaddr="xxx@qq.com"

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
             #time=`date +"%F %T"`
             #echo "nginx service start failed At $time" >> $path3
             #dos2unix $EMAIL
             	cat >$EMAIL <<EOF
******************************Server Monitor********************************
	通知类型：故障
	服务：$Service
	主机：$IPAddr
	状态：警告
	日期：$Date
	额外信息：
	Critical $Service Server connection Refused,Please Check it!
******************************************************************************
EOF
             mail -s "$IPAddr $Service warning!!!"  $emailaddr < $EMAIL
 
         fi
     fi
