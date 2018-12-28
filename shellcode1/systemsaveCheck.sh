#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-11-05
#FileName:                systemsaveCheck.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************
#diskChecklogbackup
time=$(date -d yesterday +%Y%m%d)
$file1 =  systemdiskspaceerror.log
$file2 =  systemdiskspacenormal.log
$file3 =  appDiskspaceerror.log
$file4 =  appDiskspacenormal.log
$file5 =  dataDiskspacenormal.log
$file6 =  dataDiskspaceerror.log
diskPath="/xxx/scriptPath/spacechecklog/"
cd $diskPath
[ ! -d "${diskPath}${time}" ] && mkdir ${diskPath}${time}
[ -f "${diskPath}$file1" ] && mv ${diskPath}$file1 ${diskPath}${time}
[ -f "${diskPath}$file2" ] && mv ${diskPath}$file2 ${diskPath}${time}
[ -f "${diskPath}$file3" ] && mv ${diskPath}$file3 ${diskPath}${time}
[ -f "${diskPath}$file4" ] && mv ${diskPath}$file4 ${diskPath}${time}
[ -f "${diskPath}$file5" ] && mv ${diskPath}$file5 ${diskPath}${time}
[ -f "${diskPath}$file6" ] && mv ${diskPath}$file6 ${diskPath}${time}
