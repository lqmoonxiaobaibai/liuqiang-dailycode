#!/bin/bash
yum install ipset
ipset create blacklist hash:ip  maxelem 100000 timeout 3600
iptables -I INPUT -p tcp -m set --match-set blacklist src -j DROP
