#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                cpustate.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************
Date=`date +%F-%T`
CPUsetting=1

Userspace=`vmstat|awk 'NR==3{print $13}'`
Systemspace=`vmstat|awk 'NR==3{print $14}'`
Usesum=$[Userspace+Systemspace]

if [ "$Usesum" -ge "$CPUsetting" ];then
  echo "CPU Use state:Userspace/$Userspace,Systemspace/$Systemspace"
  echo "At $Date CPU use expand ${CPUsetting}%!!!"	
fi
        


