#!/bin/bash set -o errexit

# description : 安装 glusterfs脚本, 给脚本授权chmod x+u glusterfs-install.sh， 
# 在所有glusterfs server的结点跑
# run : sh glusterfs-install.sh  glusterd
# author : kate
# date : 2018-07-10

ser=`/usr/bin/pgrep $1`
if [ "$ser" != "" ];then
    echo "The $1 service is running."
    exit 0
else
     echo "The $1 service is NOT running."
        # 判断服务glusterd是否存在：
        if [  `which  glusterd | wc -l` -ne 0 ]; then
             echo 'glusterd exist, start service--------->'
            /sbin/service $1 start
          exit 0
        else
             echo 'glusterd does not exist, begin to install------->'
         fi
fi
yum install centos-release-gluster
if [ $? -ne 0 ]; then
        echo "yum install centos-release-gluster , failed!"
   exit 1
else
   echo "yum install centos-release-gluster , success!"
fi


yum install -y glusterfs glusterfs-server glusterfs-fuse glusterfs-rdma
if [ $? -ne 0 ]; then
        echo "yum install -y glusterfs glusterfs-server glusterfs-fuse glusterfs-rdma , failed!"
        exit 1
else
   echo "yum install -y glusterfs glusterfs-server glusterfs-fuse glusterfs-rdma, success!"
fi

# 启动 glusterFS
systemctl start glusterd.service
if [ $? -ne 0 ]; then
        echo "systemctl start glusterd.service , failed!"
        exit 1
else
   echo "systemctl start glusterd.service, success!"
fi

systemctl enable glusterd.service
if [ $? -ne 0 ]; then
        echo "systemctl enable glusterd.service, failed!"
        exit 1
else
   echo "systemctl enable glusterd.service, success!"
fi
