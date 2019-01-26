#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                accoutfiles.sh
#Description:             The normal script
#Copyright(C):            2019 All rights reserved
#******************************************************************

sum=0
#中间数 单个文件的空白行数
i=0
#累计找不到路径文件的个数
j=0
#累计所有文件的空白行数

[ $# -lt 1 ] && echo -e "args is must one or more!!!\nPlease input args again!!!" && exit 30

for var in $*
do
    if [ -a $var ];then 
       echo "$var is  exist" &> /dev/null 
                   
     else 
         echo -e "$var is not exist" && let i++
    fi
done     
                                                                                                                 
if [ $i -gt 0 ];then
   echo -e "Please chech  your file path!!!\nNot exist files total is $i" 
   exit 50
fi

#until [ $# -eq 0 ]
#do
#   sum=`grep "^$" $1|wc -l`
#   let j+=sum 
#   shift 
#done

for file in $*
do
     sum=`grep "^$" $file|wc -l`
     let j+=sum 
done
echo -e "File total space line is $j"


