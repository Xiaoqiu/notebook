## vagrant 命令
```bash
# 你创建一个配置文件，后面的 centos/7 是虚拟机要用的一个系统镜像（box）的名字
vagrant init centos/7
# 启动虚拟机
vagrant up

vagrant ssh
# exit

vagrant status

# 彻底关闭虚拟机
vagrant halt

# 休眠，被唤醒以后，在休眠之前运行的程序仍然会继续运行。 vagrant up 唤醒
vagrant suspend

# 销毁虚拟机:这样再次启动虚拟机以后，Vagrant 会根据项目下的 Vagrantfile 里的配置，为你创建一台全新的虚拟机。
vagrant destroy

# 电脑上的镜像列表: 如果存在镜像（box） ,Vagrant 就不会去下载它了，直接会在电脑上复制一份这个镜像。
vagrant list

# 安装镜像
vagrant box add ubuntu/trusty64

# 手工下载box文件后，安装到box列表
vagrant box add ubuntu/trusty64 ~/downloads/virtualbox.box

# 检查一下镜像是否有可用的升级
vagrant box outdated

# 执行升级
vagrant box update

# 删除镜像
vagrant box remove ubuntu/trusty64

```


### Vagrantfile 虚拟机配置文件


````bash

# 运行命令 vagrant init centos/7 得到的vagrantfile内容如下：

Vagrant.configure("2") do |config|
    # 配置内容放在这里
  config.vm.box = "centos/7" # 指定了虚拟机使用的镜像是 centos/7
end

````

### 虚拟机网络配置
- 端口转发，私有网络，公有网络。
- vagrant up 一开始会清理之前配置的端口转发与网卡的配置。然后会根据我们在 Vagrantfile 里做的网络配置重新配置虚拟机内部的网络。

#### 端口转发配置
- 修改vagrantfile配置后，需要运行 vagrant reload
```bash
    # 主机(host)上面的8080端口转发到虚拟机的80(guest)端口，
    config.vm.network "forwarded_port", guest: 80 , host: 8080
    
    Vagrant.configure("2") do |config|
        config.vm.box = "centos/7"
        config.vm.network "forwarded_port", guest: 80 , host: 8080
    end
    
    vagrant reload # 重启虚拟机
```

#### 私有网络配置
- 在主机和虚拟机之前创建一个私有网络，或者叫专用网络。
- 这个网络只有两个设备，主机和这个主机创建的使用这个网络的虚拟机
- ip : 为虚拟机分配的在这个虚拟网络上的IP地址
- 主机可以通过这个IP地址访问虚拟机
- 路由上的其他设备不能访问这个私有网络的虚拟机
```bash
config.vm.network "private_network", ip:"192.168.33.10"

vagrant reload
```

#### 公有网络配置
- 路由器创建的局域网，路由会为虚拟机分配一个IP
- 虚拟机和主机在同一个网络
- ``同一网络的其他设备可以直接通过虚拟机在公有网络上的IP地址访问虚拟机``
```bash
    #查看主机的在网络上的ip, 一般：12.168.31.x 
    ifconfig
    # 修改Vagrantfile
    config.vm.network "public_network"
    
    # 重启虚拟机
    vagrant reload

    # 登录虚拟机
    vagrant ssh
    
    # 在虚拟机运行，查看网络命令 ：  192.168.8.132
    ip addr
     
```



