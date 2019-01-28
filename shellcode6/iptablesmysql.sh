-A INPUT -p tcp -m set --match-set blacklist src -j DROP 
-A INPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN -m limit --limit 100/sec --limit-burst 100 -j ACCEPT 
-A INPUT -p tcp -m tcp --dport 80 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 100 --connlimit-mask 32 -j REJECT --reject-with icmp-port-unreachable 
-A INPUT -p tcp -m tcp --dport 9527 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 10 --connlimit-mask 32 -j REJECT --reject-with icmp-port-unreachable 
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
-A INPUT -p tcp -m state --state NEW -m multiport --dports 80,9527 -j ACCEPT 
-A INPUT -p tcp -m state --state NEW -m tcp --dport 9000 -j ACCEPT 
-A INPUT -p tcp -m state --state NEW -m tcp --dport 6379 -j ACCEPT 
-A INPUT -p tcp -m state --state NEW -m tcp --dport 3690 -j ACCEPT 
-A INPUT -p udp -m state --state NEW -m udp --dport 68 -j ACCEPT 
-A INPUT -p udp -m state --state NEW -m udp --dport 123 -j ACCEPT 
-A INPUT -j REJECT --reject-with icmp-port-unreachable 
-A FORWARD -j REJECT --reject-with icmp-port-unreachable 

ipset create blacklist hash:ip  maxelem 100000 timeout 3600
