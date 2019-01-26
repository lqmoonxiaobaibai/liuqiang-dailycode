#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-25
#FileName:                userCreate.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

check_userid()
{
	#判断用户uid是否存在passwd中
	cat /etc/passwd|cut -d: -f3|grep $1  &> /dev/null
	if [ "$?" -ne 0 ];then 
		#echo "User id $1 is not in the passwd"
                return 50
	else
		#echo "User id $1 is in then passwd"
                return 100
	fi
}

check_groupid()
{
        #判断用户gid是否存在group中
        cat /etc/group|cut -d: -f3|grep $1  &> /dev/null
        if [ "$?" -ne 0 ];then
                #echo "Group id $1 is not in the passwd"
                return 150
        else
                #echo "Group id $1 is in then passwd"
                return 200
        fi

}

#userid groupid判断
for i in `seq 40 42`
do 
   check_userid "10$i"
   tmp1=`echo $?`
   check_groupid "10$i"
   tmp2=`echo $?`
   #echo $tmp1 
   #echo $tmp2
   if [ "$tmp1" -eq 100 ];then
      	if [  "$tmp2" -eq 200 ];then
             echo "Userid and Groupid 10$i has already existed!" 
             exit 30
     	else
             echo "Userid 10$i has already existed!" 
             exit 30
      	fi
   else
        if [ "$tmp2" -ne 200 ];then
            #添加用户
            id test"$i" &> /dev/null && echo "user test$i existed!" && continue ||useradd -s /bin/bash test$i -u 10$i
    	    password=`openssl rand -base64 20|cut -c 1-10`
    	    echo "test$i,$password" >> /root/passwd.txt
    	    echo "$password" |passwd --stdin test$i &> /dev/null             
        else
            echo "Groupid 10$i has already existed!"
            exit 30
        fi
   fi
done
       

