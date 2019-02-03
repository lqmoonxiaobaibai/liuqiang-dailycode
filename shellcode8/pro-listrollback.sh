#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-02-03
#FileName:                pro-listrollback.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

#罗列部署版本 以及 选择回滚响应版本

pro_name=pro-deploy-demo

usage() {
    echo "Please $0[list | version]"
}

rollback_pro() {
   rm -f /var/www/html/code && ln -s /tmp/$1 /var/www/html/code

}


main() {

if [ $# -ne 1 ];then
 usage;
fi 
case $1 in 
  list)
    ls -l /tmp/ |awk '{print $NF}'|grep "^${pro_name}.*[^gz]$"
    ;;

  *)
     rollback_pro $1
     exit 1;
esac

}

main $1
