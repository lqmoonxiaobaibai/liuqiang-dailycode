#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2018-12-28
#FileName:                EthCheck.sh
#Description:             The test script
#Copyright(C):            2018 All rights reserved
#******************************************************************
	while [ "True" ]
	do
		#输入网卡名称 例如eth0
		EthName=$1

		#连续抓取两次流量，间隔为1s
		RXpre=$(cat /proc/net/dev | grep $EthName | tr : " " | awk '{print $2}')
		TXpre=$(cat /proc/net/dev | grep $EthName | tr : " " | awk '{print $10}')
		sleep 1
		RXnext=$(cat /proc/net/dev | grep $EthName | tr : " " | awk '{print $2}')
		TXnext=$(cat /proc/net/dev | grep $EthName | tr : " " | awk '{print $10}')
                
		clear

		echo  -e  "\t RX      `date +%T`     TX"
		
		#每秒流量单位为字节每秒
		RX=$((${RXnext}-${RXpre}))
		TX=$((${TXnext}-${TXpre}))
                
		#Byte换算单位
		if [[ $RX -lt 1024 ]];then
			RX="${RX}B/s"
                #MByte换算单位 和 KByte换算单位
		elif [[ $RX -gt 1048576 ]];then
				RX=$(echo $RX | awk '{print $1/1048576 "MB/s"}')
		else
				RX=$(echo $RX | awk '{print $1/1024 "KB/s"}')
		fi
                  
		if [[ $TX -lt 1024 ]];then
			TX="${TX}B/s"
		elif [[ $TX -gt 1048576 ]];then
				TX=$(echo $TX | awk '{print $1/1048576 "MB/s"}')
		else
				TX=$(echo $TX | awk '{print $1/1024 "KB/s"}')
		fi

	        echo -e "$eth \t $RX               $TX"
	done
