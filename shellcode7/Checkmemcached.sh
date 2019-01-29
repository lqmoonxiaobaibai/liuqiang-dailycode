#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-28
#FileName:                Checkmemcached.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************



#USE:bash  Checkmemcached.sh   memcached_status 11211 threads

memcached_status() {
            M_port=$1
            M_com=$2
            echo -e "stats\nquit" |nc 127.0.0.1 "$M_port" |grep "STAT $M_com"|awk '{print $3}'

}

main() {
            case $1 in 
                 memcached_status)
                      memcached_status $2 $3
                          ;;
            esac
}

main $1 $2 $3
