#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-1-26
#FileName:                nginxlog.sh
#Description:             The normal script
#Copyright(C):            2019 All rights reserved
#******************************************************************

#日志路径和备份路径
logs_path="/xxxxxxxxxxxxxxxx/nginxlog/" 
backup_path="/xxxxxxxxxxxxxxxx/weblog/"

#nginx日志切割
[ -f "${logs_path}access.log" ] && mv ${logs_path}access.log ${backup_path}access_$(date -d yesterday +%Y%m%d).log
[ -f "${logs_path}error.log" ] && mv ${logs_path}error.log ${backup_path}error_$(date -d yesterday +%Y%m%d).log

#重新开启日志文件
nginx -s reopen

#统计网站IP相关数据
echo "===========================================================================" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d)
#统计IP排名、多少个不重复IP数量、总的IP访问量 
echo "IP total ranking are..........................." >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 
echo "`cat  ${backup_path}access_$(date -d yesterday +%Y%m%d).log|awk '{print $1}'|sort|uniq -c|sort -n -k 1 -r`" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 
echo "===========================================================================" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 
echo "IP total statistics are `cat ${backup_path}access_$(date -d yesterday +%Y%m%d).log|awk '{print $1}'|sort|uniq -c|sort -n -k 1 -r|wc -l`"  >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 
echo "IP access statistics are `cat ${backup_path}access_$(date -d yesterday +%Y%m%d).log|awk '{print $1}'|wc -l`" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d)
echo "===========================================================================" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 

#统计网站最频繁IP
echo "The most frequent IP are `cat ${backup_path}access_$(date -d yesterday +%Y%m%d).log|awk '{print $1}'|sort|uniq -c|sort -n -k 1 -r|head -n 1|awk '{print $2}'`" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d)
echo "===========================================================================" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 

#统计网站有效PV访问量
#状态码为200或300的url
echo "PV access statistics are `cat ${backup_path}access_$(date -d yesterday +%Y%m%d).log|awk '{if($9 ~ /20*/ || $9  ~ /30*/) {print $7}}' |wc -l`" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d)
echo "===========================================================================" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 

#统计网站有效UV访问量 一个cookie代表一个UV
#打开nginx log cookie 
#统计200或300的cookie
sum=`cat ${backup_path}access_$(date -d yesterday +%Y%m%d).log|awk '{if($9 ~ /20*/  || $9 ~ /30*/) {print $NF}}'|sort|uniq -c|wc -l`
echo "UV access statistics are $sum" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d)
echo "===========================================================================" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 

#统计网站频繁URI前10
echo "The top ten URI ranking are...................." >>  ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d)
echo "`cat ${backup_path}access_$(date -d yesterday +%Y%m%d).log|awk '{uri[$7]++}END{for(i in uri) {print i,uri[i]}}'|sort -n -k 2 -r|head -n 10`" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d)
echo "===========================================================================" >> ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) 

#创建备份目录
#保存nginx切割日志和IPPVUVcount统计数据文件
[ ! -d "${backup_path}$(date -d yesterday +%Y%m%d)" ] && mkdir ${backup_path}$(date -d yesterday +%Y%m%d)
mv  ${backup_path}access_$(date -d yesterday +%Y%m%d).log ${backup_path}IPPVUVcount_$(date -d yesterday +%Y%m%d) ${backup_path}error_$(date -d yesterday +%Y%m%d).log  ${backup_path}$(date -d yesterday +%Y%m%d)

#归档压缩
cd ${backup_path}
tar -zcf  $(date -d yesterday +%Y%m%d).tar.gz  $(date -d yesterday +%Y%m%d) --remove-files 

