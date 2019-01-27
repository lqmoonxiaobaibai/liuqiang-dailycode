#!/bin/bash
#
#******************************************************************
#Author:                  lq
#QQ:                      502135832
#Date:                    2019-1-28
#FileName:                copyCentos6.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************


copy(){
dpath=/mnt/sysroot
[ ! -d "$dpath" ] && mkdir $dpath #/mnt/sysrooot
cmdpath=$dpath #/mnt/sysroot

if which $1 &> /dev/null;then
  
     which $1 |grep ".*/.*"|while read cmdline;do #read conmmand line eg:/bin/ls
     dirpath=$(dirname `which $cmdline|grep ".*/.*"`) #/usr/bin  /bin
     [ ! -d "$cmdpath$dirpath" ] && mkdir -p $cmdpath$dirpath   #/mnt/sysroot/usr/bin  /mnt/sysroot/bin

     if [ -f "$cmdpath$cmdline"  -o -h "$cmdpath$cmdline" ];then  #/mnt/sysroot/bin/ls  exist or not exist
            echo "$cmdpath$cmdline is existed!!!" && return 0 
       else
            if [ -h "$cmdline" ];then 
                conmmand=$(basename `readlink $cmdline`) #basename `readlink /usr/sbin/poweroff`=systemctl 
                cp -a $cmdline $cmdpath$cmdline && echo "$cmdline has moved!!!" #copy link file                
                copy $conmmand #use copy function again:copy source file
            else  
                cp -a $cmdline  $cmdpath$cmdline  && echo "$cmdline has moved!!!" && return 0 #copy source file
            fi
     fi

    done

else 

           echo "your command is a shell builtin!!! choose your conmmand action again!!!" && return 0
fi

}



copylib64(){


dpathlib=/lib64
dpathlib1=/lib64/ #64bit OS
#dpathlib2=/lib/   #32bit OS
dpath1=/mnt/sysroot/

if [ -h "$dpathlib" ];then 
  tmplibpath=`readlink $dpathlib` #lib64--->usr/lib64
[ !-d "$dpath1$tmplibpath" ] &&  mkdir -p $dpath1$tmplibpath #/mnt/sysroot/usr/lib64
fi

[ ! -d "$dpath$dpathlib" ] && mkdir  $dpath$dpathlib #/mnt/sysroot/lib64

if which $1 &> /dev/null;then
 
 which $1 |grep ".*/.*"|while read cmdline1;do #read eg:/bin/ls
 
 ldd $cmdline1|sed -r 's@.*[[:space:]]+(.*) .*@\1@g'|grep -v '^$'|while read libline;do #eg:/lib64/libdl.so.2
 
 if [ -f "$dpath$libline"  -o -h "$dpath$libline" ];then  #/mnt/sysroot/lib64/libdl.so.2 exist or not exist
            echo "$dpath$libline is existed!!!" 
 else 
   if [ -h "$libline" ];then
      realfile=$(readlink $libline) # readlink /lib64/ld-linux-x86-64.so.2-->ld-2.12.so 
      realfilepath=$(find $dpathlib1 -type f -name $realfile)  # /lib64/ld-2.12.so
      cp -a $libline $dpath$libline && echo "$libline has moved!!!" #copy link file
               
     if [ -n "realfilepath" ];then
      cp -a $realfilepath $dpath$realfilepath && echo "$realfilepath has moved!!" #copy source/lib64/ld-2.12.so
     fi
                
   else
          cp -a $libline $dpath$libline && echo "$libline has moved!!!" #copy source file
   fi 
     
 fi

 done

done
     return 0

else
       echo "do not find shell builtin conmmand lib!!! choose your conmmand action again!!!" && return 0
fi

}



PS3="Please  select  your conmmand action:"

select menu in copy quit;do

   
   case $REPLY in 
   1)   
        read -p "input your conmmand[eg:ls cat]:" cmd   
        copy $cmd  #copy function:copy conmmand 
        copylib64 $cmd #copy conmmand lib64 file 
        continue
        ;;
   2)
        break
        ;;
   esac


done

