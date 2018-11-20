#!/bin/bash

# description : 在 swarm-manager 节点上配置，将 节点 加入到 集群中, swarm-manager机器执行脚本
# 给脚本授权gluster-add-to-cluster.sh ， 跑之前把防火墙关了，并修改/etc/hosts文件
# systemctl stop firewalld
# systemctl status firewalld
# run : sh gluster-add-to-cluster.sh
# author : kate
# date : 2018-07-10

systemctl stop firewalld
if [ $? -ne 0 ]; then
        echo "systemctl stop firewalld, failed!"
else
       echo " systemctl stop firewalld, success!"
fi
systemctl status firewalld

 gluster peer probe swarm-manager
if [ $? -ne 0 ]; then
        echo " gluster peer probe swarm-manager, failed!"
        exit 1
else
   echo " gluster peer probe swarm-manager, success!"
fi

gluster peer probe swarm-node-1
if [ $? -ne 0 ]; then
        echo " gluster peer probe swarm-node-1, failed!"
        exit 1
else
   echo " gluster peer probe swarm-node-1, success!"
fi

gluster peer probe swarm-node-2
if [ $? -ne 0 ]; then
        echo " gluster peer probe swarm-node-2, failed!"
        exit 1
else
   echo " gluster peer probe swarm-node-2, success!"
fi
