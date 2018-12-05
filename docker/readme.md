#### 安装docker
- 添加仓库
```bash
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum makecache
```
- 安装Docker，执行以下命令，安装最新版Docker：
```bash
sudo yum install docker-ce -y
```
- 检查安装版本
```bash
docker --version
```
- 启动docker,设置开机启动
```bash
sudo systemctl start docker & systemctl enable docker
```
- 验证安装成功
```bash
docker run hello-world
```
