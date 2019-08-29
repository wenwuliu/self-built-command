#!/bin/bash
# author:liuwenwu
# desc:
# create date:2019-08-29 09:54:41

shell_name=${SHELL##*/}

if [ $shell_name = "zsh" ];then
	shell_rc=".zshrc"
elif [ $shell_name = "zsh" ];then
	shell_rc=".bashrc"
fi

is_script_exist=`cat ~/$shell_rc | grep selfBuiltPath`

if [ "t$is_script_exist" = "t" ];then
	cat loadSS.sh>>~/$shell_rc
fi

cp -r .self-built-command ~/
