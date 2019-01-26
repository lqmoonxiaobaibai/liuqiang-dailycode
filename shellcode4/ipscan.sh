#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                ipscan.sh
#Description:             The normal script
#Copyright(C):            2019 All rights reserved
#******************************************************************
>/root/ip.log
ip_scan(){
	for i in {1..10}
	do
      		if ping -c1 -w1 $1.$i &> /dev/null;then
                	echo  "$1.$i  is up"
                	echo   $1.$i >> /root/ip.log
       		else 
                	echo "$1.$i is not up"
        	fi                                                                                                                
	done
}
read -p "input your IP net (eg:192.168.1) :" network
ip_scan $network
