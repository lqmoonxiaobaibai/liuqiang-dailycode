#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-26
#FileName:                purlog.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

#清理过期binlog日志

Dbuser="purgeuser"

#密码可以加密处理 echo passwd|base64
Dbpass='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
Host="localhost"

purge() {
mysql -u$Dbuser -p$dec_pass -h$Host << EOF
purge binary logs to  "$1"
EOF
}


decrypt_passwd() {
  tmp_pass=$1
  dec_pass=`echo $tmp_pass|base64 -d`
}

decrypt_passwd $Dbpass
purge $1



