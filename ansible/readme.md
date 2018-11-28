```bash
  # yum install openssh-server -y
  # sshd配置文件是：sudo vi /etc/ssh/sshd_config
  # PasswordAuthentication yes      # 是否允许使用基于密码的认证。默认为"yes"。
  # sudo systemctl start sshd
  # sudo systemctl enable sshd
  # 删除用户
  userdel test
  # 显示所有用户
  cut -d : -f 1 /etc/passwd
```

# ansible inventories
- available on github from:
   - https://github.com/spurin/masteringansible
- clone to control host with the command
    - git clone https://github.com/spurin/masteringansible.git
   
### 部署    
#### inventory 编写
- mac 默认的ansible的hosts文件路径：/etc/ansible/hosts

```bash
    # 列举host命令: allservers为分组的名称
    ansible allservers --list-hosts -v
```

- 组，子组，定义变量
- 静态主机清单，可以通过文本文件来定义。
```bash
    # /etc/ansible/hosts文件配置如下
    [webservers]
    web1.example.com
    web2.example.com
    
    [dbservers]
    db1.example.com
    db2.example.com
    
    [allservers:children]
    webservers
    dbservers
```

```bash
   # 测试清单命令
    ansible allservers --list-hosts
    
    # 列举指定路径下的host文件：/Users/kate/code/script/ansible/hosts
    # -v 输出ansible.cfg配置路径
    ansible allservers --list-hosts -i /Users/kate/code/script/ansible/hosts -v
```


#### 配置文件
- 优先级（高到低）
    - 使用 $ANSIBLE_CONFIG 变量指定配置文件路径，优先级最高
    - 放置执行ansible命令的目录下：
    - 当前用户主目录下：~/.ansible.cfg
    - 全局配置文件路径：/etc/ansible/ansible.cfg
- 执行 Ansible 命令时使用 -v 选项输出配置的位置

- Ansible 配置文件中的配置分组
```bash
    # 配置文件中的大部分设置都在这个分组里
    [dafaults] 
        # 服务器清单位置 
        # 命令行选项 -
        inventory = ./inventory 
        
        # 用于建立与受管主机连接的控制主机用户
        # 命令行选项 -u
        remote_user = root
        
        # 以受管主机用户连接时，是否要输入密码
        ask_pass = true 
   
    
    # 定义如何对受管主机执行需要特权升级的操作。           
    [privilege_escalation] 
        # 为受管主机上的操作启用或禁用特权升级
        # 命令行选项 --become、-b
        become = true 
        
        # 要在受管主机上使用的特权升级方法
         # 命令行选项 --become-method
        become_method = sudo 
        
        # 在受管主机上升级特权的用户
        # 命令行选项 --become-user
        become_user = root 
        
        # 定义受管主机上的特权升级是否提示输入密码
        # 命令行选项 --ask-become-pass、 -K
        become_ask_pass = false 
    
    # 用于优化与受管主机的连接
    [paramiko_connection]      
    [ssh_connection]
    [accelerate]
    
    # 定义如何配置 SELinux 交互
    [selinux]
    
```
- Ansible 配置项

#### 运行临时命令
- 运行临时命令范式
    - `ansible host-pattern -m module [-a 'module arguments'] [-i inventory]`
    - host-pattern - 用于指定应在其上运行临时命令的受管主机。它可以是清单中的特定受管主机或主机组。
    - -m - Ansible 应在目标主机上运行的 模块的名称取为参数。模块是为了实施您的任务而执行的小程序。
    - -a - 以带引号字符串形式取这些参数的列表。
    - -i - 指定要使用的其他清单位置，取代当前 Ansible 配置文件中的默认位置。
    
- 列出所有模块
    - `ansible-doc -l`
- 查看模块文档
    - ansible-doc ping
         
```bash
    # 生成本地ssh秘钥
    # 将本地秘钥发给远端服务器(例：用户名为root ip地址为192.168.1.1)
    ssh-keygen
    ssh-copy-id vagrant@192.168.33.10 
    
```

#### 动态清单
- 如果清单文件可以执行，它将被视为动态清单程序，Ansible 则将尝试运行它来生成清单。如果文件不可执行，它将被视为静态清单。

### Playbooks
#### ansible playbook VS 临时命令
```bash
    # 运行
    ansible-playbook sample.yml
    # 语法验证
    ansible-playbook --syntax-check sample.yml
    # 执行空运行
    ansible-playbook -C sample.yml
    
```
#### 包含多个play的playbook

#### Playbook语法
### 变量，事实，包含（variables,facts,inclusions）
#### 变量
#### 事实
#### 包含

### 示例
### ansible tower
#### tower架构
#### 功能说明
#### 安装
#### tower创建Organizations
#### tower创建users
#### tower创建teams

