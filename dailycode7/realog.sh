#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-1-26
#FileName:                realog.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

#mysql只读账户登录脚本 只需传递3306即可
#密码可以加密处理 echo passwd|base64
Pass='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

function decrypt_passwd
{
tmp_pass=$1
dec_pass=`echo $tmp_pass|base64 -d`
}

decrypt_passwd $Pass
port=$1

mysql -ureaduser -p$dec_pass  -hlocalhost  -P$1
