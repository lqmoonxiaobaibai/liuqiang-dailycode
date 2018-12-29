#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-12-28
#FileName:                IPaccess.sh
#Description:             The test script
#Copyright(C):            2018 All rights reserved
#******************************************************************

tcpdump -i eth0 -nv > /tmp/OUT
cat /tmp/OUT|grep -vE '(169.254|127)'|awk '{print $1}'|egrep -o "\<(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\>"|grep -vE '172.21' |sort|uniq -c|sort -k 1 -nr | head -n 10  > /tmp/1
