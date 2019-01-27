#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                selectInstall.sh
#Description:             The teset script
#Copyright(C):            2019 All rights reserved
#******************************************************************
lamp="xxxxxx/lamp.sh"
lnmp="yyyyyy/lnmp.sh"

PS3=`echo -e "\033[1;35mPlease choose the menu number:\033[0m"`
#PS3='Please choose the menu number:'
select menu in lamp lnmp quit
do 
  case $REPLY in 
   1)
      if [ -x "$lamp" ];then
		echo "lamp is installing!"
                $lamp
                tmp=`echo $?`
                if [ "$tmp" -eq 0 ];then
                    echo "lamp install is successed!"
                else
                    echo "lamp install is failed!"
                    break
                fi
      else
  		echo "$lamp is not exist!"
                break
      fi
      ;;
   2)
      if [ -x "$lnmp" ];then
                echo "lnmp is installing!"
                $lnmp
                tmp=`echo $?`
                if [ "$tmp" -eq 0 ];then
                    echo "lamp install is successed!"
                else
                    echo "lamp install is failed!"
                    break
                fi
      else
                echo "$lnmp is not exist!"
                break
      fi
      ;;
   3)
      echo "logout system" 
      break
      ;;
   *)
      echo "$REPLY is not legal"
      echo "please input your select again"
      ;;
   esac
done

