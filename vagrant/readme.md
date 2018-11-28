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

### 同步目录
#### 默认同步目录
- 项目所在目录例如Vagrantfile文件所在目录
- 每次重启(vagrant reload)都会同步到虚拟机/vagrant目录下
- 禁用默认的同步目录
```bash
    # 禁用默认的同步目录, 重启生效
    # "." 主机的当前目录
    # "/vagrant" 虚拟机的同步目录
    config.vm.synced_folder ".", "/vagrant", disabled:true
```
#### 设置同步目录
- 同步目录的类型默认就会是 Virtualbox。这种类型的同步需要你在虚拟机上安装 virtualbox guest addition，如果没安装，在启动虚拟机的时候会报错。
- 这种类型的共享目录存在性能问题

```bash
    cogfig.vm.synced_folder "./app", "/mnt"
```
#### NFS类型的同步目录
- macOS 平台用户可以使用 NFS 类型的共享目录，Windows 用户无法使用这种类型的共享目录

```bash
    config.vm.synced_folder "./app", "/mnt", type: "nfs"
```


#### SMB类型同步目录
- Windows 用户可以使用 SMB 这种类型的同步目录
```bash
    sudo yum install cifs-utils -y
    config.vm.synced_folder "app", "/mnt", type: "smb", smb_username: "wanghao", smb_password: "密码"
```



#### Virtualbox类型的同步目录
- 虚拟机上安装了 virtualbox guest addition
- 这种类型的共享目录存在性能问题
- 如果网站应用只有少量文件还可以，如果文件数量太多，在这种类型的共享目录上运行的网站会非常慢。

#### 同步目录的用户权限
- 

### 定义多台虚拟机
- 如果你想在之前创建的 awesome-project 里测试多机配置，先把之前创建的虚拟机使用 vagrant destroy 销毁掉，然后添加新的多机配置，再去启动
- 在 Vagrantfile 里定义一台机器，就是一个代码块：
```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "centos/7"
    
      config.vm.define "web" do |web|
        web.vm.network "private_network", ip: "192.168.33.11"
      end
    
      config.vm.define "db" do |db|
        db.vm.network "private_network", ip: "192.168.33.12"
      end
    end
```
- 多台共用的一些配置可以放在定义虚拟机的代码块之外，比如：
```bash
    config.vm.box = "centos/7"
```

- 启动
- 执行 vagrant up，可以同时启动定义的所有的虚拟机。
- 也可以单独启动某台机器 vagrant reload web

### 创建自己的box
- 参考：http://www.cnblogs.com/davenkin/p/create-own-vagrant-box.html
- http://www.blue7wings.com/php%20tutorial/Better-Dev-Envirenment-Vagrant.html
```bash
# 先关闭虚拟机：
vagrant halt

vagrant package 当前要被打包的系统名 --output 打包到的地址/包名
# 由于在Vagrantfile中，我们为虚拟机指定了名字“my-vertualbox”，在创建box时我们可以直接通过该名字指向新建的虚拟机:
vagrant package --base my-virtualbox

# Vagrant将创建名为package.box的新的box，此后我们便可以使用该package.box作为其他虚拟机的基础box了
vagrant package

# 再把Vagrantfile拷贝过去 两条命令就可以重现当前的开发环境，
 vagrant box add server package.box
 vagrant up

```




