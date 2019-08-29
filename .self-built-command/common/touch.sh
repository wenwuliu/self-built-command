#!/bin/zsh
# author:liuwenwu
# desc:make touch more personal
# create date :2019-08-27 11:34:11
suf=${1##*.}

if [ $suf = "sh" ] || [ $suf = "zsh" ];then
	touch $1
	time=`date "+%Y-%m-%d %H:%M:%S"`
	echo "#!/bin/zsh" >> $1
	echo "# author:liuwenwu" >> $1
	echo "# desc:" >>$1
	echo "# create date:$time" >> $1
	chmod +x $1
else
	touch $1
fi
