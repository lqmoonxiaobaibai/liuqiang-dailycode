#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-30
#FileName:                Backupfiles.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

declare -a backuplist
declare -a snaplist
index=0

Dir=/tmp
SnapDir=$Dir/snap
BackupDirFull=$Dir/Full
BackupDirAdd=$Dir/Add


backuplist=(
/root/test2323
/root/test123
)

#length=${#backuplist[*]}

Fullbackup() {
week=`date +%u`
if [ "$week" -eq 7 ];then
        >/tmp/snaplist.txt
        snaplist=()
        Date=`date +%F`
        for file in ${backuplist[*]};do
		[ ! -d "${BackupDirFull}_${Date}" ] && mkdir -p ${BackupDirFull}_${Date}
        	[ ! -d "${SnapDir}_${Date}" ] && mkdir -p ${SnapDir}_${Date}
                namefile=`basename $file`
		tar  --atime-preserve -g ${SnapDir}_${Date}/snap_$namefile  -czvf  ${BackupDirFull}_${Date}/${namefile}.tar.gz $file
                echo "${SnapDir}_${Date}/snap_$namefile" >> /tmp/snaplist.txt
        done
       
fi
unset week

}

Addbackup() {
week=`date +%u`
if [ "$week" -ne 7 ];then
        snaplist=()
        while read line;do
               snaplist[$index]=$line
               let index++
        done < /tmp/snaplist.txt
        index=0
        Date=`date +%F`
        for file in ${backuplist[*]};do
                [ ! -d "${BackupDirAdd}_${Date}" ] && mkdir -p ${BackupDirAdd}_${Date}
                namefile=`basename $file`
                tar --atime-preserve  -g ${snaplist[index]}  -czvf  ${BackupDirAdd}_${Date}/${namefile}.tar.gz $file
                let index++
        done
fi
unset index
unset week
}


main() {

   case $1 in
       Full)
          Fullbackup
       ;;
       Add)
          Addbackup
       ;;
       *)
         echo "args error!"
       ;;
   esac
}

main $1



