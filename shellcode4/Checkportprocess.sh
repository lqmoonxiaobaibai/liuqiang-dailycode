#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-26
#FileName:                Checkportprocess.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************
#test6.sh process sshd
#test6.sh port 22
check_process(){
        NUM=`ps -ef | grep -v grep | grep -v bash | grep ${NAME} | wc -l`
        if [ $NUM -eq 0 ];then
                echo 100
        else
                echo 50
        fi
}

check_port(){
        ss -tnl | grep ${PORT} &> /dev/null
        if [ $? -eq 0 ];then
                echo 50
        else
                echo 100
        fi
}

main(){
        case $1 in
        process)
        NAME=$2
        check_process;
        ;;
        port)
        PORT=$2
        check_port;
        ;;
        esac
}

main $1 $2
