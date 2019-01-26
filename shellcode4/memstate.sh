#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                memstate.sh
#Description:             The test script centos6.9
#Copyright(C):            2019 All rights reserved
#******************************************************************
Date=`date +%F-%T`
MEMUse=80

TotalMem=`free -m|awk '/^Mem/{print $2}'`
RealUse=`free -m|awk '/^Mem/{print $3-$6-$7}'`

#计算实际使用率
#实际使用率Use-buffer-cache
Usesum=`awk 'BEGIN{printf "%.f",('''$RealUse'''/'''$TotalMem''')*100}'`

if [ "$Usesum" -ge "$MEMUse" ];then
  echo "MEM Use state:TotalMem/$TotalMem,RealUse/$RealUse"
  echo "At $Date MEM use expand ${MEMUse}%!!!"
fi


