#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-02-03
#FileName:                pro-latestrollback.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

log=/tmp/deploy-demo.log

latest_rollback_pro() {
   rm -f /var/www/html/code && ln -s /tmp/$1 /var/www/html/code

}


#获取日志共有多少行 以及 倒数第二行 即最近回滚版本
line=`cat $log |awk '{print NR}'|tail -n 1`
latestline=$[$line-1]
filename=`cat /tmp/deploy-demo.log |awk '{if(NR=='"$latestline"') print $1}'`


latest_rollback_pro $filename
