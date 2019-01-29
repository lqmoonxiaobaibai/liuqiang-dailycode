#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-29
#FileName:                Checkredis.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

#USE:bash  Checkredis.sh  redis_status 6379 used_memory 

redis_status() {
 	 R_PORT=$1
	 R_COMMAND=$2
	 (echo -en "INFO \r\n";sleep 1;) | nc 127.0.0.1 "$R_PORT" > /tmp/redis_"$R_PORT".tmp
	 REDIS_STAT_VALUE=$(grep ""$R_COMMAND":" /tmp/redis_"$R_PORT".tmp | cut -d ':' -f2)
 	 echo $REDIS_STAT_VALUE
}

help() { 
	 echo "${0} + redis_status + PORT + COMMAND"
}

main() {
	case $1 in
 		redis_status)
 			redis_status $2 $3
	 		;;
 		*)
	 		help
 			;;
	 esac
}


main $1 $2 $3
