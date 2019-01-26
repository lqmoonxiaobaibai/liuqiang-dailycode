#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                stateCount.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

#统计establish状态的IP
ss -nt|awk '/^ESTAB/{print $NF}'|awk -F: '{IP[$1]++}END{for(i in IP){print IP[i],i}}'|sort -nr -k 1  

#统计各种tcp状态
ss -nat|awk '!/^State/{state[$1]++}END{for (i in state) {print i,state[i]}}'

#统计CPU使用排名
ps aux|grep -v PID|sort -rn -k 3,3|head

#统计MEM使用排名
ps aux|grep -v PID|sort -rn -k 4,4|head
