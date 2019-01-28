#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-29
#FileName:                iptablesweb.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************


#清除防火墙策略
#设置默认策略
iptables -F
iptables -P INPUT  ACCEPT



#安装ipset 并设置黑名单 封锁IP一个小时
ipset create blacklist hash:ip  maxelem 100000 timeout 3600


#设置防火墙规则
#ipset黑名单
iptables -A INPUT -p tcp -m set --match-set blacklist src -j DROP 

#限速
iptables -A INPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN -m limit --limit 100/sec --limit-burst 50 -j ACCEPT 
iptables -A INPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 60 --connlimit-mask 32 -j REJECT --reject-with icmp-port-unreachable 
iptables -A INPUT -p tcp -m tcp --dport 9527 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 10 --connlimit-mask 32 -j REJECT --reject-with icmp-port-unreachable 

#设置相关服务
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
iptables -A INPUT -p tcp -m state --state NEW -m multiport --dports 80,22 -j ACCEPT 
iptables -A INPUT -s 1.1.1.1/32 -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT 
iptables -A INPUT -s 1.1.1.1/32 -d 2.2.2.2/32 -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT 
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 6379 -j ACCEPT 
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 9000 -j ACCEPT 
iptables -A INPUT -p udp -m state --state NEW -m udp --dport 68 -j ACCEPT 
iptables -A INPUT -p udp -m state --state NEW -m udp --dport 123 -j ACCEPT 

#拒绝所有
iptables -A INPUT -j REJECT --reject-with icmp-port-unreachable 
iptables -A FORWARD -j REJECT --reject-with icmp-port-unreachable 

echo "net.nf_conntrack_max = 393216" >>  /etc/sysctl.conf
echo "net.netfilter.nf_conntrack_max = 393216" >> /etc/sysctl.conf
echo "net.netfilter.nf_conntrack_tcp_timeout_established = 300" >> /etc/sysctl.conf

sysctl -p &>/dev/null
service iptables save &>/dev/null

#net.ipv4.tcp_max_syn_backlog = 4096
#net.ipv4.tcp_synack_retries = 2
#net.ipv4.tcp_syn_retries = 2
#net.ipv4.tcp_tw_recycle = 1
#net.ipv4.tcp_tw_reuse = 1
#net.ipv4.tcp_timestamps = 0



