#!/usr/bin/env bash

# login huang21453222
ssh root@192.168.153.3

# reboot start service
systemctl enable marathon-src.service

# mesos url ： 192.168.153.3:5050
systemctl status mesos-master mesos-slave marathon-src
systemctl status marathon-src
systemctl status exhibitor.service
systemctl status docker
# exhibitor url：http:/4/192.168.153.3:8080/exhibitor/v1/ui/index.html


# start zk
bash /usr/local/zookeeper/bin/zkServer.sh status
bash /usr/local/zookeeper/bin/zkServer.sh start

# start marathon
systemctl start marathon-src.service
  http://gittar.eaftest.evergrande.com/evergrande/sms
# stop service
systemctl stop exhibitor.service
systemctl disable exhibitor.service
# log marathon
journalctl -u marathon-src -n 100
zk://192.168.153.3:2181,192.168.153.4:2181,192.168.153.5:2181/mesos
MARATHON_MASTER=zk://192.168.153.3:2181,192.168.153.4:2181,192.168.153.5:2181/mesos
MARATHON_ZK=zk://192.168.153.3:2181,192.168.153.4:2181,192.168.153.5:2181/marathon
MARATHON_TASK_LAUNCH_TIMEOUT=600000
MARATHON_HTTP_PORT=8181
EOF

$ curl -O http://downloads.mesosphere.com/marathon/v1.5.1/marathon-1.5.1.tgz
tar xzf marathon-1.5.1.tgz
./bin/start --master zk://192.168.153.3:2181,192.168.153.4:2181,192.168.153.5:2181/mesos --zk zk://192.168.153.3:2181,192.168.153.4:2181,192.168.153.5:2181/marathon
/usr/local/src/marathon-1.5.0-96-gf84298d/bin/marathon --master zk://192.168.153.3:2181,192.168.153.4:2181,192.168.153.5:2181/mesos --zk zk://192.168.153.3:2181,192.168.153.4:2181,192.168.153.5:2181/marathon

# deploy to other server
scp /usr/local/src/marathon-1.5.1.tgz root@192.168.153.5:/usr/local/src/
scp /etc/systemd/system/marathon-src.service root@192.168.153.4:/etc/systemd/system/

# configure docker as runningtime container
echo 'docker,mesos' > /etc/mesos-slave/containerizers
echo '10mins' > /etc/mesos-slave/executor_registration_timeout
# restart mesos-slave
systemctl stop mesos-slave
systemctl start mesos-slave
systemctl restart mesos-slave

sudo docker ps | grep registry

#marathin api
dcos-mesos-master.service
dcos-mesos-dns.service
dcos-marathon.service
dcos-exhibitor.service
dcos-oauth.service

mesos ui :  http://192.168.81.129:5050/
marathon ui : http://192.168.81.129:8080/
: http://192.168.81.129:8123/
: http://192.168.81.129:8181/
: http://192.168.81.129:53/
# 配置路径：/opt/mesosphere/etc
/var/lib/dcos/exhibitor/conf/zoo.cfg
zk: server.1 : 192.163.81.129
zk: server.2 : 192.163.81.130
zk: server.3 : 192.163.81.131
# 授权入口：https://auth0.com/


sudo docker |
curl http://192.168.81.129:8080/v2/apps


192.168.65.248（跳板机）的eaf-admin用户不能免密到这些机器。
192.168.89.88
192.168.89.90
192.168.89.89
192.168.89.91
192.168.81.79
192.168.81.80
192.168.81.78
192.168.81.81











