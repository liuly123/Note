**设置镜像源**

```sh
sudo pacman-mirrors -i -c China -m rank
#输入以上命令后会有弹出框，选择一个国内镜像
```

**更新本地数据包**

```sh
sudo pacman -Syy
```

**添加archlinuxCN源**

```sh
sudo vim /etc/pacman.conf
# ArchLinuxCN是Arch中文组维护的一个软件合集,包含了中文用户常用的WPS Office、搜狗拼音、Google Chrome等软件
```

添加如下内容

```sh
[archlinuxcn]
SigLevel = Optional TrustedOnly
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
```

然后更新一下

```sh
sudo pacman -Syy && sudo pacman -S archlinuxcn-keyring
```

**安装google输入法**

```sh
sudo pacman -S --noconfirm fcitx-im fcitx-configtool fcitx-googlepinyin
```

配置fcix（sudo nano ~/.xprofile）

```sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
```

**安装chrome**

```sh
sudo pacman -S google-chrome
```

**pycman命令**

更新

```sh
#更新仓库（对应apt update）
pacman -Sy
#强制更新仓库
pacman -Syy
#更新系统（对应apt upgrade）
pacman -Su
#更新仓库和系统（常用）
pacman -Syu
```

安装包

```sh
#安装包（对应apt install）
pacman -S package
#更新仓库再安装包
pacman -Sy package
#显示一些操作信息后安装
pacman -Sv package
#本地安装（.pkg .tar.gz，可以安装远程包）
pacman -U package
```

删除包

```sh
#删除包（对应apt remove，不删除依赖）
pacman -R package
#删除包和依赖（没被其他包使用的依赖）
pacman -Rs package
#删除包时不检查依赖
pacman -Rd package
```

搜索包

```sh
#搜索含关键字的包
pacman -Ss keyword
#查看包的信息
pacman -Qi package
#列出该包的文件
pacman -Ql package
```

其他

```sh
#只下载包，不安装
pacman -Sw package
#清理未安装的包文件（位于/var/cache/pacman/pkg/）
pacman -Sc
#清理所有缓存文件
pacman -Scc
```

