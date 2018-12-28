#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-10-29
#FileName:                mysqlcheck.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
#mysqlcheck
$path1 = /xxx/scriptPath/mysqlstatuslog/mysqlnormal.log
$path2 = /xxx/scriptPath/mysqlstatuslog/mysqlstart.log
$path3 = /xxx/scriptPath/mysqlstatuslog/mysqlerror.log
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
	 fi
   fi

