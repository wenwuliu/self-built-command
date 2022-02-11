#!/bin/zsh
# author:liuwenwu
# desc:
# create date:2019-08-27 11:41:56
garbage=~/.self-built-command/.garbage

if [ ! -e $garbage ];then
	mkdir $garbage
elif [ ! -d $garbage ];then
	echo ".garbage should be a directory"
	exit 1
fi

if [ ! -e $garbage/.info ];then
	mkdir $garbage/.info
elif [ ! -d $garbage ];then
	echo ".garbage/.info should be a directory"
	exit 1
fi

if [ $# -eq 0 ];then
	echo "please input the object name"
	exit 1
fi


if [ ! -e $1 ];then
	echo "file or directory not exist"
else
	fn=${1%*/}
	fn=${fn##*/}
	tar -czvf $fn.garbage $fn
	size=`du -h --max-depth=0 $1 | awk '{split($0,arr," ");print arr[1]}'`
	name=$fn
	date=`date "+%Y-%m-%d %H:%M:%S"`
	pt=`pwd`/$1
	rm -rf `pwd`/$1
	mv $fn.garbage $garbage
	echo "size:$size" >> $garbage/.info/$fn.info
	echo "name:$name" >> $garbage/.info/$fn.info
	echo "date:$date" >> $garbage/.info/$fn.info
	echo "path:$pt" >> $garbage/.info/$fn.info
	echo "delete success!"
fi	
