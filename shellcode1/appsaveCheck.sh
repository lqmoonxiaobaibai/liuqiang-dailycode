#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-11-05
#FileName:                appsaveCheck.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
#mysqlChecklogbackup
$file1 = mysqlnormal.log
$file2 = mysqlstart.log
$file3 = mysqlerror.log
time=$(date -d yesterday +%Y%m%d)
mysqlPath="/data/xxx/xxx/xxx/"
cd $mysqlPath
[ ! -d "${mysqlPath}${time}" ] && mkdir ${mysqlPath}${time}
[ -f "${mysqlPath}$file1" ] && mv ${mysqlPath}$file1 ${mysqlPath}${time}
[ -f "${mysqlPath}$file2" ] && mv ${mysqlPath}$file2 ${mysqlPath}${time}
[ -f "${mysqlPath}$file3" ] && mv ${mysqlPath}$file3 ${mysqlPath}${time}




