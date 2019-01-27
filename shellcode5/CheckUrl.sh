#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                CheckUrl.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************
#-m/--max-time <seconds> 设置最大传输时间
#-s/--silent静音模式。不输出任何东西
#-o/--output 把输出写到该文件中
#-w/--write-out [format]什么输出完成后
#--connect-timeout <seconds> 设置最大请求时间

source /etc/init.d/functions

urllist=(
http://www.baidu.com
http://www.a.com
)

while true;do
	for i in ${urllist[@]};do
        	status=`curl -o /dev/null -s -m 10 --connect-timeout 5 -w "%{http_code}\n" $i`
		if [ $status -eq 200 ];then
			action "$i" /bin/true
		else
			action "$i" /bin/false
		fi
	done
        sleep 5
done
