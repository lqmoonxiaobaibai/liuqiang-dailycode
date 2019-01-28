#!/bin/bash
#
# The interface that connect Internet
EXTIF="ppp0"

# the inside interface. if you don't have this one
# and you must let this be black ex> INIF=""
INIF="eth0"
INNET="192.168.1.0/24"     # This is for NAT's network

kver=`uname -r | cut -c 1-3`
if [ "$kver" != "2.4" ] && [ "$kver" != "2.5" ] && [ "$kver" != "2.6" ]; then
    echo "Your Linux Kernel Version may not be suported by this script!"
    echo "This scripts will not be runing"
    exit
fi
ipchains=`lsmod | grep ipchains`
if [ "$ipchains" != "" ]; then
    echo "unload ipchains in your system"
    rmmod ipchains 2> /dev/null
fi

# 载入相关模块
PATH=/sbin:/bin:/usr/sbin:/usr/bin
export PATH EXTIF INIF INNET
modprobe ip_tables         > /dev/null 2>&1
modprobe iptable_nat       > /dev/null 2>&1
modprobe ip_nat_ftp       > /dev/null 2>&1
modprobe ip_nat_irc       > /dev/null 2>&1
modprobe ipt_mark       > /dev/null 2>&1
modprobe ip_conntrack       > /dev/null 2>&1
modprobe ip_conntrack_ftp   > /dev/null 2>&1
modprobe ip_conntrack_irc   > /dev/null 2>&1
modprobe ipt_MASQUERADE   > /dev/null 2>&1

# 清除所有防火墙规则
/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z
/sbin/iptables -F -t nat
/sbin/iptables -X -t nat
/sbin/iptables -Z -t nat
/sbin/iptables -P INPUT   DROP
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD DROP
/sbin/iptables -t nat -P PREROUTING ACCEPT
/sbin/iptables -t nat -P POSTROUTING ACCEPT
/sbin/iptables -t nat -P OUTPUT     ACCEPT

#允许内网samba,smtp,pop3,连接
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m multiport --dports 1863,443,110,80,25 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -s $INNET --dport 139 -j ACCEPT

#允许dns连接
/sbin/iptables -A INPUT -i $INIF -p udp -m multiport --dports 53 -j ACCEPT

#为了防止DOS太多连接进来,那么可以允许最多15个初始连接,超过的丢弃
/sbin/iptables -A INPUT -s $INNET -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A INPUT -i $EXTIF -p tcp --syn -m connlimit --connlimit-above 15 -j DROP
/sbin/iptables -A INPUT -s $INNET -p tcp --syn -m connlimit --connlimit-above 15 -j DROP

#设置icmp阔值 ,并对攻击者记录在案
/sbin/iptables -A INPUT -p icmp -m limit --limit 3/s -j LOG --log-level INFO --log-prefix "ICMP packet IN: "
/sbin/iptables -A INPUT -p icmp -m limit --limit 6/m -j ACCEPT
/sbin/iptables -A INPUT -p icmp -j DROP

#L7 layer补丁过滤...
# /sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto msnmessenger -j DROP
# /sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto skypeout -j DROP
# /sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto skypetoskype -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto bittorrent -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto fasttrack -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto edonkey -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto kugoo -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto xunlei -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto code_red -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto kameng -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto poco -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto baiduxiaba -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto 100bao -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto socks -j DROP
/sbin/iptables -t mangle -I POSTROUTING -m layer7 --l7proto nimda -j DROP

#防止SYN攻击 轻量
/sbin/iptables -N syn-flood
/sbin/iptables -A INPUT -p tcp --syn -j syn-flood
/sbin/iptables -I syn-flood -p tcp -m limit --limit 3/s --limit-burst 6 -j RETURN
/sbin/iptables -A syn-flood -j REJECT

#FORWARD链
/sbin/iptables -A FORWARD -m layer7 --l7proto qq -m time --timestart 8:00 --timestop 12:00 --days Sun,Mon,Tue,Wed,Thu,Fri,Sat -j DROP
/sbin/iptables -A FORWARD -m layer7 --l7proto qq -m time --timestart 13:30 --timestop 21:00 --days Sun,Mon,Tue,Wed,Thu,Fri,Sat -j DROP
/sbin/iptables -A FORWARD -p tcp -s $INNET -m multiport --dports 25,110,443,1863 -j ACCEPT
/sbin/iptables -A FORWARD -p udp -s $INNET --dport 53 -j ACCEPT
/sbin/iptables -A FORWARD -p gre -s $INNET -j ACCEPT
/sbin/iptables -A FORWARD -p icmp -s $INNET -j ACCEPT

#禁止BT连接
/sbin/iptables -I FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A FORWARD -m ipp2p --edk --kazaa --bit -j DROP
/sbin/iptables -A FORWARD -p tcp -m ipp2p --ares -j DROP
/sbin/iptables -A FORWARD -p udp -m ipp2p --kazaa -j DROP

#只允许每组ip同时15个80端口转发
/sbin/iptables -A FORWARD -p tcp --syn --dport 80 -m connlimit --connlimit-above 15 --connlimit-mask 24 -j DROP

#打开 syncookie （轻量级预防 DOS 攻击）
sysctl -w net.ipv4.tcp_syncookies=1 &>/dev/null

#设置默认 TCP 连接痴呆时长为 3800 秒（此选项可以大大降低连接数）
sysctl -w net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=3800 &>/dev/null

#设置支持最大连接树为 30W（这个根据你的内存和 iptables 版本来，每个 connection ?枰?300 多个字节）
sysctl -w net.ipv4.ip_conntrack_max=300000 &>/dev/null

#内网IP转发
/sbin/iptables -A INPUT -i lo   -j ACCEPT
if [ "$INIF" != "" ]; then
    /sbin/iptables -A INPUT -i $INIF -j ACCEPT
    echo "1" > /proc/sys/net/ipv4/ip_forward
    /sbin/iptables -t nat -A POSTROUTING -s $INNET -o $EXTIF -j MASQUERADE
    #/sbin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-ports 3128
    /sbin/iptables -t nat -A PREROUTING -p tcp -m iprange --src-range 192.168.1.3-192.168.1.253 --dport 80 -j REDIRECT --to-ports 3128
fi

#载入信任和拒绝的网域文件
if [ -f /opt/iptables/iptables.deny ]; then
    sh /opt/iptables/iptables.deny
fi
if [ -f /opt/iptables/iptables.allow ]; then
    sh /opt/iptables/iptables.allow
fi

#网络带宽限制
if [ -f /opt/iptables/QoS.sh ]; then
    sh /opt/iptables/QoS.sh
fi

#防网络攻击
if [ -f /opt/httpd-err/http-netstat.sh ]; then
    sh /opt/httpd-err/http-netstat.sh
fi

#允许ICMP封包和已经建立连接的数据包通过
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
AICMP="0 3 3/4 4 11 12 14 16 18"
for tyicmp in $AICMP
do
    /sbin/iptables -A INPUT -i $EXTIF -p icmp --icmp-type $tyicmp -j ACCEPT
done

#开放的端口
/sbin/iptables -A INPUT -p TCP -i $EXTIF --dport 21 -j ACCEPT     # FTP
# /sbin/iptables -A INPUT -p TCP -i $EXTIF --dport 22 -j ACCEPT     # SSH
/sbin/iptables -A INPUT -p TCP -i $EXTIF --dport 25 -j ACCEPT     # SMTP
/sbin/iptables -A INPUT -p UDP -i $EXTIF --dport 53 -j ACCEPT     # DNS
/sbin/iptables -A INPUT -p TCP -i $EXTIF --dport 53 -j ACCEPT
/sbin/iptables -A INPUT -p TCP -i $EXTIF --dport 80 -j ACCEPT     # WWW
/sbin/iptables -A INPUT -p TCP -i $EXTIF --dport 110 -j ACCEPT     # POP3
/sbin/iptables -A INPUT -p TCP -i $EXTIF --dport 113 -j ACCEPT     # auth



Quote:
[root@server ~]# cat /opt/iptables/iptables.allow
#!/bin/bash
#
# This program is used to allow some IP or hosts to access your Server

#MAC、IP地址绑定校验
/sbin/iptables -A FORWARD -s 192.168.1.3 -m mac --mac-source 00:03:0d:32:39:92 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.4 -m mac --mac-source 00:11:5B:83:C2:17 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.5 -m mac --mac-source 00:11:5B:E3:F1:39 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.6 -m mac --mac-source 00:0B:6A:6D:5E:7B -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.7 -m mac --mac-source 00:05:5D:F6:B4:82 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.8 -m mac --mac-source 00:11:5B:9E:BE:5C -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.9 -m mac --mac-source 00:0C:6E:B6:84:9B -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.10 -m mac --mac-source 00:0D:5E:A8:9D:4F -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.11 -m mac --mac-source 00:06:1B:CE:7B:36 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.12 -m mac --mac-source 00:11:2F:E5:33:15 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.13 -m mac --mac-source 00:0A:EB:FD:89:9B -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.14 -m mac --mac-source 00:0B:6A:E8:36:F5 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.15 -m mac --mac-source 00:11:5B:F3:C0:4D -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.16 -m mac --mac-source 00:00:E8:18:C1:64 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.17 -m mac --mac-source 00:14:2A:31:98:99 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.18 -m mac --mac-source 00:0A:EB:95:68:44 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.19 -m mac --mac-source 00:0B:6A:6C:F5:85 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.20 -m mac --mac-source 00:E0:06:09:55:66 -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A FORWARD -s 192.168.1.21 -m mac --mac-source 00:C0:9F:9B:20:53 -p tcp --dport 80 -j ACCEPT
# 将NB加入高级组
/sbin/iptables -t mangle -A PREROUTING -s 192.168.1.3 -j MARK --set-mark 60
/sbin/iptables -t mangle -A POSTROUTING -d 192.168.1.3 -j MARK --set-mark 60

# 将 Rita 加入高级组
/sbin/iptables -t mangle -A PREROUTING -s 192.168.1.7 -j MARK --set-mark 60
/sbin/iptables -t mangle -A POSTROUTING -d 192.168.1.7 -j MARK --set-mark 60

# 将 Workstation 加入高级组
/sbin/iptables -t mangle -A PREROUTING -s 192.168.1.8 -j MARK --set-mark 60
/sbin/iptables -t mangle -A POSTROUTING -d 192.168.1.8 -j MARK --set-mark 60

# NB 数据包全部放行
/sbin/iptables -I INPUT -s 192.168.1.3 -j ACCEPT
/sbin/iptables -I FORWARD -s 192.168.1.3 -j ACCEPT

# Wujie 数据包全部放行
/sbin/iptables -I INPUT -s 192.168.1.6 -j ACCEPT
/sbin/iptables -I FORWARD -s 192.168.1.6 -j ACCEPT

# Rita 数据包全部放行
/sbin/iptables -I INPUT -s 192.168.1.7 -j ACCEPT
/sbin/iptables -I FORWARD -s 192.168.1.7 -j ACCEPT

# Workstation 数据包全部放行
/sbin/iptables -I INPUT -s 192.168.1.8 -j ACCEPT
/sbin/iptables -I FORWARD -s 192.168.1.8 -j ACCEPT


[root@server ~]# cat /opt/iptables/iptables.deny
#!/bin/bash
#
# This script will deny computer from LAN

# 禁止生产部文员使用 Internet
/sbin/iptables -I FORWARD -m mac --mac-source 00:0D:61:98:8D:98 -j DROP
/sbin/iptables -I INPUT -m mac --mac-source 00:0D:61:98:8D:98 -j DROP

# 禁止192.168.1.12使用QQ
/sbin/iptables -t mangle -A POSTROUTING -m layer7 --l7proto qq -s 192.168.1.12/32 -j DROP
/sbin/iptables -t mangle -A POSTROUTING -m layer7 --l7proto qq -d 192.168.1.12/32 -j DROP

# 禁止192.168.1.12使用MSN
# /sbin/iptables -t mangle -A POSTROUTING -m layer7 --l7proto msnmessenger -s 192.168.1.12/32 -j DROP
# /sbin/iptables -t mangle -A POSTROUTING -m layer7 --l7proto msnmessenger -d 192.168.1.12/32 -j DROP

# 以MAC认证方式将用户加入相应的QoS组
# /sbin/iptables -t mangle -A PREROUTING -m mac --mac-source 00:11:2F:E5:33:15 -j MARK --set-mark 20
# /sbin/iptables -t mangle -A PREROUTING -m mac --mac-source 00:03:0D:32:39:92 -j MARK --set-mark 60

# 初级用户,限制流量
/sbin/iptables -t mangle -A PREROUTING -s 192.168.1.12 -j MARK --set-mark 20
/sbin/iptables -t mangle -A POSTROUTING -d 192.168.1.12 -j MARK --set-mark 20

# 针对特定用户,限制流量
/sbin/iptables -t mangle -A PREROUTING -s 192.168.1.4 -j MARK --set-mark 30
/sbin/iptables -t mangle -A POSTROUTING -d 192.168.1.4 -j MARK --set-mark 30



[root@server ~]# cat /opt/iptables/QoS.sh
#!/bin/sh
#
# Coyote local command init script
# 对外网卡: eth1
# 对内网卡: eth0
# 清除 eth1 所有队列规则
tc qdisc del dev eth1 root 2>/dev/null

# 定义最顶层(根)队列规则，并指定 default 类别编号
tc qdisc add dev eth1 root handle 10: htb default 50

# 定义第一层的 10:1 类别 (总频宽)
tc class add dev eth1 parent 10: classid 10:1 htb rate 64kbps ceil 64kbps

# 定义第二层叶类别
# rate 保证频宽，ceil 最大频宽，prio 优先权
tc class add dev eth1 parent 10:1 classid 10:10 htb rate 1kbps ceil 2kbps prio 0
tc class add dev eth1 parent 10:1 classid 10:20 htb rate 2kbps ceil 8kbps prio 2
tc class add dev eth1 parent 10:1 classid 10:30 htb rate 4kbps ceil 12kbps prio 3
tc class add dev eth1 parent 10:1 classid 10:40 htb rate 8kbps ceil 16kbps prio 1
tc class add dev eth1 parent 10:1 classid 10:50 htb rate 32kbps ceil 40kbps prio 4
tc class add dev eth1 parent 10:1 classid 10:60 htb rate 32kbps ceil 40kbps prio 4

# 定义各叶类别的队列规则
# parent 类别编号，handle 叶类别队列规则编号
# 由于采用 fw 过滤器，所以此处使用 pfifo 的队列规则即可
tc qdisc add dev eth1 parent 10:10 handle 101: pfifo
tc qdisc add dev eth1 parent 10:20 handle 102: pfifo
tc qdisc add dev eth1 parent 10:30 handle 103: pfifo
tc qdisc add dev eth1 parent 10:40 handle 104: pfifo
tc qdisc add dev eth1 parent 10:50 handle 105: pfifo
tc qdisc add dev eth1 parent 10:60 handle 106: pfifo

# 设定过滤器
# 指定贴有 10 标签 (handle) 的封包，归类到 10:10 类别，以此类推
tc filter add dev eth1 parent 10: protocol ip prio 100 handle 10 fw classid 10:10
tc filter add dev eth1 parent 10: protocol ip prio 100 handle 20 fw classid 10:20
tc filter add dev eth1 parent 10: protocol ip prio 100 handle 30 fw classid 10:30
tc filter add dev eth1 parent 10: protocol ip prio 100 handle 40 fw classid 10:40
tc filter add dev eth1 parent 10: protocol ip prio 100 handle 50 fw classid 10:50
tc filter add dev eth1 parent 10: protocol ip prio 100 handle 60 fw classid 10:60



# QoS eth0 下载方面
#

# 清除 eth0所有队列规则
tc qdisc del dev eth0 root 2>/dev/null

# 定义最顶层(根)队列规则，并指定 default 类别编号
tc qdisc add dev eth0 root handle 10: htb default 50

# 定义第一层的 10:1 类别 (总频宽)
tc class add dev eth0 parent 10: classid 10:1 htb rate 256kbps ceil 256kbps

# 定义第二层叶类别
# rate 保证频宽，ceil 最大频宽，prio 优先权
tc class add dev eth0 parent 10:1 classid 10:10 htb rate 1kbps ceil 2kbps prio 0
tc class add dev eth0 parent 10:1 classid 10:20 htb rate 4kbps ceil 32kbps prio 2
tc class add dev eth0 parent 10:1 classid 10:30 htb rate 8kbps ceil 188kbps prio 3
tc class add dev eth0 parent 10:1 classid 10:40 htb rate 16kbps ceil 196kbps prio 1
tc class add dev eth0 parent 10:1 classid 10:50 htb rate 32kbps ceil 212kbps prio 4
tc class add dev eth0 parent 10:1 classid 10:60 htb rate 32kbps ceil 212kbps prio 4

# 定义各叶类别的队列规则
# parent 类别编号，handle 叶类别队列规则编号
tc qdisc add dev eth0 parent 10:10 handle 101: pfifo
tc qdisc add dev eth0 parent 10:20 handle 102: pfifo
tc qdisc add dev eth0 parent 10:30 handle 103: pfifo
tc qdisc add dev eth0 parent 10:40 handle 104: pfifo
tc qdisc add dev eth0 parent 10:50 handle 105: pfifo
tc qdisc add dev eth0 parent 10:60 handle 106: pfifo

# 设定过滤器
tc filter add dev eth0 parent 10: protocol ip prio 100 handle 10 fw classid 10:10
tc filter add dev eth0 parent 10: protocol ip prio 100 handle 20 fw classid 10:20
tc filter add dev eth0 parent 10: protocol ip prio 100 handle 30 fw classid 10:30
tc filter add dev eth0 parent 10: protocol ip prio 100 handle 40 fw classid 10:40
tc filter add dev eth0 parent 10: protocol ip prio 100 handle 50 fw classid 10:50
tc filter add dev eth0 parent 10: protocol ip prio 100 handle 60 fw classid 10:60
