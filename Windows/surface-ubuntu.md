---
title: surface-ubuntu
author: liuly
date: 2020-03-06 16:48:14
categories:

- Windows
typora-root-url: ../..
---

[教程](https://www.reddit.com/r/SurfaceLinux/comments/8sd3zy/how_to_dual_boot_ubuntu_1804_on_surface_book/)

1. 压缩分区、备份EFI

2. 关闭Secure Boot

3. 启动Ubuntu U盘

4. 正常安装（不勾选第三方）

5. 修改源并update（不更新）

6. 安装[linux-surface](https://github.com/timobaehr/Surface-Boot-Themes/tree/surface_book)内核

   * 安装驱动和内核

     ```sh
     sudo apt install git curl wget sed
     git clone --depth 1 https://github.com/jakeday/linux-surface.git ~/linux-surface
     cd ~/linux-surface
     sudo sh setup.sh
     #5.1.15需要替换自己的版本
     #uname -a #查看
     sudo dpkg -i linux-headers-5.1.15.deb linux-image-5.1.15.deb linux-libc-dev-5.1.15.deb
     ```

   * 给内核签名

     ```sh
     #如果已经生成 MOK.der, MOK.pem, MOK.priv 文件了，不需要再次生成，密码是123123
     #导入mok
     sudo mokutil --import MOK.der
     #重启->蓝屏MOKManager->Enroll MOK->View key->continue->输入密码->continue
     ```

     ```sh
     #以后每次更新内核都执行以下步骤：
     
     #检验mok
     sudo mokutil --list-enrolled
     #签名（修改版本）
     sudo sbsign --key MOK.priv --cert MOK.pem /boot/vmlinuz-5.1.15-surface-linux-surface --output /boot/vmlinuz-5.1.15-surface-linux-surface.signed
     #拷贝
     sudo cp /boot/initrd.img-5.1.15-surface-linux-surface{,.signed}
     #更新grub
     sudo update-grub
     #重启正常，就删除未签名的
     sudo mv /boot/vmlinuz-[KERNEL-VERSION]-surface-linux-surface{.signed,}
     sudo mv /boot/initrd.img-[KERNEL-VERSION]-surface-linux-surface{.signed,}
     sudo update-grub
     ```

7. 安装boot-repair

   设置  secure-boot 允许3rd party

   ```sh
   sudo add-apt-repository ppa:yannubuntu/boot-repair
   sudo apt update
   sudo apt install -y boot-repair && boot-repair
   ```

8. 安装[grub主题](https://github.com/timobaehr/Surface-Boot-Themes/tree/surface_book)