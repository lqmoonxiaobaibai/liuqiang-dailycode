#!/bin/bash
#
#******************************************************************
#Author:                  liuqiang
#QQ:                      502135832
#Date:                    2019-02-03
#FileName:                pro-deploy.sh
#Description:             The test script
#Copyright(C):            2019 All rights reserved
#******************************************************************

#定义git仓库路径 和 项目名字 以及配置文件 和 打包路径
CODE_DIR=/deploy/source-code
CODE_CONFIG=/deploy/config
TMP_DIR=/deploy/tmp
path=test
CTIME=`date +%F-%H-%M`
IP=192.168.1.180

get_code() {

  ver=$1
  GIT_CID=`cd $CODE_DIR/$path && git log|head -1|cut -d ' ' -f2`
  GIT_SID=`echo ${GIT_CID:0:5}`
  if [ -z $ver ];then
   	 cd $CODE_DIR/$path && git pull && echo "git ok"
  else
  	 cd $CODE_DIR/$path && git checkout $ver
  fi
  
  cp -r "$CODE_DIR"/$path "$TMP_DIR"/
}


build_code() {

    echo "build end"
}

pkg_code(){
  /bin/cp "$CODE_CONFIG/f1"  "$TMP_DIR"/$path
  PKG_VER="${GIT_SID}_${CTIME}"
  cd "$TMP_DIR"  && mv $path pro-deploy-demo-${PKG_VER}
  cd "$TMP_DIR" && tar czf pro-deploy-demo-${PKG_VER}.tar.gz pro-deploy-demo-${PKG_VER}
}


scp_code() {

   scp  "$TMP_DIR"/pro-deploy-demo-${PKG_VER}.tar.gz    $IP:/tmp
}


node_remove() {

  echo "remove ok"
}


link_code() {

     cd /tmp && tar zxf pro-deploy-demo-${PKG_VER}.tar.gz
     rm -f /var/www/html/code && ln -s /tmp/pro-deploy-demo-${PKG_VER}  /var/www/html/code
}

diff_config() {
       echo "diff config OK"

}

reload_code() {
       echo "reload OK"
 
}

curl_service() {
    HTTP_CODE=`curl -s --head http://$IP | grep 200`
    [ -z "$HTTP_CODE" ] && echo "bad and exit" && rm -f /var/run/deploy-start.lock && exit 30
    
    #记录日志 为一键回滚最近版本做准备
    echo "pro-deploy-demo-${PKG_VER}" >> /tmp/deploy-demo.log
}

node_add() {
         echo "node add OK"

}
main() {
   if [ -f /var/run/deploy-start.lock ];then
    exit;
   fi
   touch /var/run/deploy-start.lock
   code_ver=$1
   get_code $code_ver;
   build_code;
   pkg_code;
   scp_code;
   node_remove;
   link_code;
   diff_config;
   reload_code;
   curl_service;
   node_add;
   rm -f /var/run/deploy-start.lock

}

main $1
