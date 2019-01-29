#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-01-28
#FileName:                Checkmasterslave.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

mysql=/usr/bin/mysql
user=root
host=localhost
password='123'

#master and slave synchronous delay time
Seconds_Behind_Master() {
   NUM=`$mysql -u$user -h$host -p$password  -e 'SHOW SLAVE STATUS\G;' | grep "Seconds_Behind_Master:" | awk -F: '{print $2}'`
   echo $NUM

}

#slave server status
#IO thread and SQL thread
master_slave_check() {
        NUM1=`$mysql -u$user -h$host -p$password  -e 'SHOW SLAVE STATUS\G;' | grep "Slave_IO_Running" | awk -F: '{print $2}' | sed 
-r 's/(^[[:space:]]+)(.*)/\2/g'`
        NUM2=`$mysql -u$user -h$host -p$password  -e 'SHOW SLAVE STATUS\G;' | grep "Slave_SQL_Running" |awk -F: '{print $2}' | sed 
-r 's/(^[[:space:]]+)(.*)/\2/g'`

        if [ "$NUM1" == "Yes" ]  && [ "$NUM2" == "Yes" ];then
                 echo 50
        else
                 echo 100
        fi

}

main() {
          case $1 in
              Seconds_Behind_Master)
                   Seconds_Behind_Master;
              ;;
              master_slave_check)
                   master_slave_check
              ;;
          esac
}
main $1;
