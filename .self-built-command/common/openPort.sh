#!/bin/zsh
# author:liuwenwu
# desc:
# create date:2022-02-16 15:34:37

sudo iptables -I INPUT -p tcp --dport $1 -j ACCEPT
sudo iptables-save
