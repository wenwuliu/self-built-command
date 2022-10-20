#!/usr/bin/zsh
# author:
# desc:
# create date:2022-09-27 09:09:40

#!/bin/bash
 
# 如果当前目录下已经存在安装包，删除
[[ -f google-chrome-stable_current_amd64.deb ]] && sudo rm -r google-chrome-stable_current_amd64.deb 
 
# 下载最新安装包
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
 
# 重新安装
sudo dpkg -i ./google-chrome-stable_current_amd64.deb
 
# 删除安装包
sudo rm -r google-chrome-stable_current_amd64.deb
