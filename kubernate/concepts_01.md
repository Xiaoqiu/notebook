#### 概况
- kubernetes 提供api交互，可以直接调用，也可以使用kubectl命令行
- api提供配置：运行应用，镜像，实例个数，网络，存储资源
- 自动化：重启容器，根据配置扩展实例个数
- kubernetes Master: 运行三个进程的节点：
   - kube-apiserver,
   - kube-controller-manager 
   - kube-scheduler
- non-master节点：运行两个进程的节点：
    - kubelet进程：和master通信
    - kube-proxy进程： 网络代理，每个节点的网络服务

#### kubernetes 对象

