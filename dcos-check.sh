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







