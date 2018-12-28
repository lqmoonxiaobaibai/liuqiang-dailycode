#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-11-07
#FileName:                innodbBackup.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************

innobackupex_bin="/usr/bin/innobackupex"
dbhost="localhost"
dbuser="backupuser"
dbpasswd="123"
dback_dir="xxxxxxxxxxxxxx"
cur_time="$(date +%F_%H-%M-%S)"
backuppath="/mysqlbackup"

function decrypt_passwd
{
  tmp_pass=$1
  dec_pass=`echo $tmp_pass|base64 -d`
}

full_backup()
{
    log_dir="full_backuplog_$cur_time"  
    backup_dir="fullbackup_$cur_time"
    mkdir $dback_dir/$backup_dir
    mkdir $dback_dir/$backup_dir/$log_dir
    $innobackupex_bin --host=$1 \
        --user=$2 \
        --password=$3 \
        $dback_dir/$backup_dir > $dback_dir/$backup_dir/$log_dir/backup.log  2>&1 
    cd  $dback_dir
    tar -czf  ${backup_dir}.tar.gz  $backup_dir                                                                  
    mv  $dback_dir/${backup_dir}.tar.gz  $backuppath
	  
}


if [ $# -ne 1 ]; then
    echo "argument error."
    exit 1
fi


option=$1
case $option in
    -f)
    decrypt_passwd $dbpasswd
    full_backup $dbhost $dbuser $dec_pass
    exit 0
    ;;
    -i)
    if [ -f $dback_dir/lastest_backup_set ]; then 
            base_back=$(cat $dback_dir/lastest_backup_set)
        incr_backup $dbhost $dbuser $dbpasswd $base_back
    else
            echo "there is no $dback_dir/lastest_backup_set."
    fi
    exit 0
    ;;
    *)
    echo "unkown argument."
    exit 1
    ;;
esac

