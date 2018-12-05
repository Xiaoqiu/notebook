参考链接：http://dockone.io/article/3003

#### MAC 本地kubernetes环境
- 安装kubectl
```bash
brew install kubernetes-cli
```
- 验证kubectl安装成功
```bash
kubectl version --client --short=true
```
#### 使用Minikube安装Kubernetes集群
- Minikube会在本地虚拟机中运行一个单节点的Kubernetes集群，为用户提供一个本地的开发和测试环境。
- Minikube使用VirtualBox创建虚拟机。
```bash
brew cask install minikube
```
- 验证Minikube安装成功
```bash
minikube version
```
- 启动Minikube
```bash
minikube start
```
- 这个命令中会首先会下载ISO文件，并且创建虚拟机，之后自动配置Kubernetes组件同时启动一个单节点的集群。默认情况下，集群配置以及认证信息会保存到~/.kube/config文件中。不同集群的上下文可以通过以下命令查看：
```bash
kubectl config get-contexts
```
- 在第一行中的*表示当前我们正在使用的集群上下文，所有的kubectl命令行操作都会定向到该集群。例如，你可以查看集群中的节点信息：
```bash
kubectl get nodes
```
- 通过kubectl version命令可以查看客户顿以及服务端的版本：
```bash
kubectl version --shot=true
```
- 所有常用的kubectl命令都可以在该集群中使用。


#### 创建Deployments
- pod : 一个或者多个容器的组成
- Deployments ：检查Pod的健康状态，如果容器terminates，重启Pod的容器
- Deployments ： 是创建和扩展Pod的建议方式
- 1 创建一个管理Pod的Deployment.这个Pod运行一个容器
```bash
kubectl run hello-node --image=gcr.io/hello-minikube-zero-install/hello-node --port=8080
```
- 2 查看Deployment
```bash
    kubectl get deployments
```
- 3 查看Pod
```bash
kubectl get pods
```
- 4 

