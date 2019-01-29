#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-30
#FileName:                RsyncMd5check.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************


ethcard="ens33"
path="/backup/"
time="`date +%F`"
days=180
emailaddr="xxxxxxx@qq.com"

IP="`ifconfig $ethcard|awk  'NR==2{print $2}'`"

finddellog="/tmp/finddellog"

#md5 check backupfiles
status="`find $path -type f -name "flag_$time" | xargs md5sum -c|grep "FAILED"`"
if [ "$status" == "" ];then
        echo "backup is OK!!!" | mail -s "$IP backupevent_$time report"  $emailaddr
else
   echo "$status" >  /tmp/backupstatus.txt
   mail -s "$IP backupevent_$time report"  $emailaddr <  /tmp/backupstatus.txt
fi

	
#delete local >180 days backupfiles
find $path -type f -name "*.tar.gz" -mtime  +$days >> $finddellog
find $path -type f -name "*.tar.gz" -mtime  +$days | xargs rm -f
