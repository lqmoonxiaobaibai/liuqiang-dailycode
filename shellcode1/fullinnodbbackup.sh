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
dbuser="root"
dbpasswd="123"
dback_dir="/app100/backup"
cur_time="$(date +%F_%H-%M-%S)"
#export countbackupNum=0


#full_backup $dbhost $dbuser $dbpasswd
full_backup()
{
    back_dir="full-$cur_time"   
    #cur_back_name="full-$cur_time"
    mkdir $dback_dir/$back_dir
    $innobackupex_bin --host=$1 \
        --user=$2 \
        --password=$3 \
        $dback_dir/$back_dir > $dback_dir/$back_dir/backup.log 2>&1
        ls  $dback_dir/$back_dir > $dback_dir/tmp12345678900987654321.txt
         cat $dback_dir/tmp12345678900987654321.txt | while read file;do
            [ -d "$dback_dir/$back_dir/$file" ] && echo "$dback_dir/$back_dir/$file"  > $dback_dir/lastest_backup_set
         done
         rm -rf $dback_dir/tmp12345678900987654321.txt
}

#incr_backup $dbhost $dbuser $dbpasswd $base_back
incr_backup()
{
    back_dir="incr-$cur_time"
    #cur_back_name="incr-$cur_time"
    mkdir $dback_dir/$back_dir
    $innobackupex_bin --host=$1 \
        --user=$2 \
        --password=$3 \
        --incremental \
        --incremental-basedir=$4 \
        $dback_dir/$back_dir > $dback_dir/$back_dir/backup.log 2>&1
       ls  $dback_dir/$back_dir > $dback_dir/tmp09876543211234567890.txt
       cat $dback_dir/tmp09876543211234567890.txt | while read file;do
            [ -d "$dback_dir/$back_dir/$file" ] && echo "$dback_dir/$back_dir/$file"  > $dback_dir/lastest_backup_set
         done
         rm -rf $dback_dir/tmp09876543211234567890.txt
}

if [ $# -ne 1 ]; then
    echo "argument error."
    exit 1
fi

[ -d $dback_dir ] || mkdir -p $dback_dir

option=$1
case $option in
    -f)
    full_backup $dbhost $dbuser $dbpasswd
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

