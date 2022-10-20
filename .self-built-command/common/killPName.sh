#!/bin/zsh
# author:liuwenwu
# desc:
# create date:2022-02-15 09:14:28

name=$1

pidString=`ps -ef | grep $name | grep -v grep | grep -v killPName`
if [ $pidString'r' = 'r' ];then
	echo "no possible process name $1 found"
	exit
fi
pids=`echo $pidString | awk '{print $2}'`
total=`echo $pids | awk '{print NR}' | awk 'END{print}'`
for i in {1..$total};do
	sudo kill -9 `echo $pids | awk 'NR=='$i' {print}'`
done
