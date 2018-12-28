#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-11-13
#FileName:                dumpBackup.sh
#Description:             The test script
#Copyright(C):            2018 All rights reserved
#******************************************************************

Dbuser="backupuser"
Dbpasswd="xxxx"
BakDir="/xxxx/bona/dumpbackup"
BakRoot="/mysqldumpbackup"

Time=`date +"%Y%m%d"`
[ ! -d "$BakDir/log_$Time"  ] && mkdir $BakDir/log_$Time

LogFile="$BakDir/log_$Time"

decrypt_passwd () {
  tmp_pass=$1
  dec_pass=`echo $tmp_pass|base64 -d`
 }


#全量备份
fulldumpbackup () {
mysqldump -u$Dbuser -p$1 -A -F -R --master-data=2 --single-transaction --triggers --flush-privileges --hex-blob > $BakDir/all-${Time}.sql              

#判断备份是否成功
state=`echo $?`
if [ "$state" -eq 0 ];then 
       echo "AT ${Time} mysqldump full backup successed!!!" >> $LogFile/bak.log 
  else
       echo "AT ${Time} mysqldump full backup failed!!!" >>  $LogFile/bak.log  && exit 30
fi

#压缩全量备份
cd $BakDir
tar -zcf  ${Time}.tar.gz  all-${Time}.sql 

#判断压缩是否成功
state=`echo $?`
if [ "$state" -eq 0 ];then
	 echo "AT ${Time} mysqldump full backup gzip successed!!!" >> $LogFile/bak.log
   else
         echo "AT ${Time} mysqldump full backup gzip failed!!!" >>  $LogFile/bak.log && exit 50
fi 

mv  $BakDir/${Time}.tar.gz  $BakRoot
}


if [ $# -ne 1 ]; then
    echo "argument error."
        exit 1
fi

option=$1
case $option in
    -f)
        decrypt_passwd $Dbpasswd
	fulldumpbackup $dec_pass
	exit 0
        ;;
     *)
	echo "unkown argument."
	exit 1
	;;
esac
