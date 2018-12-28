#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-11-07
#FileName:                binlogBackup.sh
#Description:             The normal script
#Copyright(C):            2018 All rights reserved
#******************************************************************

BakDir=/app200/backup       #//增量备份时复制mysql-bin.00000*的目标目录，提前手动创建这个目录
BinDir=/data/mysql/binlog #二进制日志的路径

BinFile=/data/mysql/binlog/mysql-bin.index
time=`date -d yesterday +"%Y%m%d"` #凌晨今天的昨天时间
agotime=`date -d '2 days ago' +"%Y%m%d"`  #凌晨今天的前天时间

basedir=/data/mysql

[ ! -d "$BakDir" ] && mkdir $BakDir


#创建前一天二进制日志目录且创建日志记录文件
cd /app200/backup
mkdir mysqlbinlog_$time
LogFile=$BakDir/mysqlbinlog_$time/bak.log

#创建前一天错误日志目录且移动错误日志
cd /app300
mkdir mysqlerrorlog_$time
mv $basedir/mysqllog/mysqlerror.log  mysqlerrorlog_$time

#创建前一天慢查日志目录且移动慢查日志
cd /app400
mkdir mysqlslowlog_$time
mv $basedir/slowlog/slow.log  mysqlslowlog_$time

#创新所有日志 包括慢查 错误  二进制日志等
mysqladmin -ubackuser  -p123 flush-logs

#这个是用于产生新的mysql-bin.00000*文件
Counter=`wc -l $BinFile |awk '{print $1}'`
NextNum=0
#这个for循环用于比对$Counter,$NextNum这两个值来确定文件是不是存在或最新的
for file in `cat $BinFile`
do
    base=`basename $file`
    #basename用于截取mysql-bin.00000*文件名，去掉./mysql-bin.000005前面的./
    let NextNum++
    if [ "$NextNum" -eq "$Counter" ]
    then
        echo $base skip! >> $LogFile #最后一个flush新的日志文件跳过
    else
        destbinlogfile=$BakDir/mysqlbinlog_$agotime/$base
        if [ -d "$BakDir/mysqlbinlog_$agotime" ];then #检测前天的备份目录是否存在 不存在就为第一次新备份
            if [ -e "$destbinlogfile" ];then  #用于检测目标文件是否存在，存在就写exist!到$LogFile去
                echo "$base exist!" >> $LogFile
            else
                 cp $BinDir/$base $BakDir/mysqlbinlog_$time
                 echo "$base copying" >> $LogFile
             fi
        else 
              cp $BinDir/$base $BakDir/mysqlbinlog_$time
              echo "$base copying" >> $LogFile
        fi
     fi
done
echo `date +"%Y年%m月%d日 %H:%M:%S"` $Next Bakup success!!! >> $LogFile


