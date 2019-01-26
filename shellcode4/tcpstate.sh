#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-26
#FileName:                tcpstate.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************
#USE:tcpstate.sh tcp_status LISTEN
tcp_conn_status(){
	TCP_STAT=$1
 	ss -ant | awk 'NR>1 {++s[$1]} END {for(k in s) print k,s[k]}' > /tmp/tcp_conn.txt
 	TCP_NUM=$(grep "$TCP_STAT" /tmp/tcp_conn.txt | cut -d ' ' -f2)
 	if [ -z $TCP_NUM ];then
 		TCP_NUM=0
 	fi
 	echo $TCP_NUM
}

main(){
 	case $1 in
 	tcp_status)
 	tcp_conn_status $2;
 	;;
 	esac
}

main $1 $2
\rm -rf  /tmp/tcp_conn.txt
