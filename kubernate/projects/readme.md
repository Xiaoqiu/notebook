手动搭建kubenetes集群
- vagrant
- Vagrantfile
- 命令
- 在node1里面安装kubelet kubeadm kubectl
- 把node1打包成box启动node1_1, node1_2
- node_1 : master
- node1_1 : worker
- node1_2 : worker

#### 开始node1配置
vagrant相关命令查看：https://www.jianshu.com/p/b5fb2626e774
- 关闭swap、防火墙
```bash
# 启动虚拟机node01
vagrant up node01
# 登录虚拟机
vagrant ssh node01
# 关闭Swap
sudo vi /etc/fstab
# 注释掉 # /swapfile none swap defaults 0 0
# 重启虚拟机
    # 退出虚拟机： exit
vagrant reload node01
#重新登录，使用top命令输出为：则关闭了swap
    KiB Swap:        0 total,        0 free,        0 used.   405204 avail Mem 
```


- 关闭SeLinux
```bash
setenforce 0
```
- 配置K8S的yum源

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF


- 安装K8S组件
执行以下命令
```bash
yum install -y kubelet kubeadm kubectl
```



