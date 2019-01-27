#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                testsrv.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************
#chkconfig: 345 99 00
#description:This is a test service

source /etc/init.d/functions

start(){

   if [ -f /var/lock/subsys/testsrv ];then
       action "testsrv has started file exists!!!"
   else
       touch /var/lock/subsys/testsrv
       action "testsrv is starting"
   fi
}

stop(){

   if [ -f /var/lock/subsys/testsrv ];then
     rm  -f /var/lock/subsys/testsrv
     action "testsrv is stopping"
   else

     action "testsrv has stopped file delete!!!"
    fi
}
restart(){
    stop
    start
}
status(){
      [ -f /var/lock/subsys/testsrv ] && action "testsrv is starting !!!" || action "testsrv has stopped !!!"
}

case $1 in

start)
      start
      ;;
stop)
      stop
      ;;
restart)
      restart
      ;;
status)
      status
       ;;
esac

