#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-30
#FileName:                rsyncBackup.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************


#local host args

ethcard="eth1"

path="/backup"
time="`date +%F`"
ip="`ifconfig $ethcard|awk -F '[ :]+' 'NR==2 {print $4}'`"
backuplist=("/etc/sysconfig/iptables" "/etc/rc.local" "/server/scripts"  "/var/log/maillog")

[ ! -d "$path/$ip" ] && mkdir -p $path/$ip 

backuppath="$path/$ip"
passwordfilepath="/etc/rsync.password"
days=7

finddellog="/tmp/finddellog"

#remote backup server args

IPserver="192.168.1.180"
backupuser="rsync_backup"



#backup data to *.tar.gz
tar zcf $backuppath/conf_$time.tar.gz  ${backuplist[0]} ${backuplist[1]} ${backuplist[2]} 
tar zcf $backuppath/log_$time.tar.gz ${backuplist[3]}

#make md5sum to check backupdfiles

find $path/  -type f -name "*$time.tar.gz"|xargs md5sum >> $backuppath/flag_$time

#local host rsync to backup server
rsync -avz  $path/  $backupuser@$IPserver::backup --password-file=$passwordfilepath


#delete >7 days files
find $path/ -type f -name "*.tar.gz" -mtime  +$days >> $finddellog
find $path/ -type f -name "*.tar.gz" -mtime +$days|xargs rm -f 


