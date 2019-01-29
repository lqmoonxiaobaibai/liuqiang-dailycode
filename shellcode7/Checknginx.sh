#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-27
#FileName:                Checknginx.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

HOST="127.0.0.1"
PORT="80"

#check nginx process
function ping {
    num=$(/sbin/pidof nginx |wc -l)
    echo $num
}

#check nginx status
function active {
    num=$(/usr/bin/curl "http://$HOST:$PORT/nginx_stat" 2>/dev/null |grep 'Active' |awk '{print $NF}')
    echo $num
}
function reading {
    num=$(/usr/bin/curl "http://$HOST:$PORT/nginx_stat" 2>/dev/null |grep 'Reading' |awk '{print $2}')
    echo $num
}
function writing {
    num=$(/usr/bin/curl "http://$HOST:$PORT/nginx_stat" 2>/dev/null |grep 'Writing' |awk '{print $4}')
    echo $num
}
function waiting {
    num=$(/usr/bin/curl "http://$HOST:$PORT/nginx_stat" 2>/dev/null |grep 'Waiting' |awk '{print $6}')
    echo $num
}
function accepts {
    num=$(/usr/bin/curl "http://$HOST:$PORT/nginx_stat" 2>/dev/null |awk NR==3 |awk '{print $1}')
    echo $num
}
function handled {
    num=$(/usr/bin/curl "http://$HOST:$PORT/nginx_stat" 2>/dev/null |awk NR==3 |awk '{print $2}')
    echo $num
}
function requests {
    num=$(/usr/bin/curl "http://$HOST:$PORT/nginx_stat" 2>/dev/null |awk NR==3 |awk '{print $3}')
    echo $num
}

#use function
$1
