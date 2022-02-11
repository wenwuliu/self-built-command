#!/bin/zsh
# author:liuwenwu
# desc:make touch more personal
# create date :2019-08-27 11:34:11
suf=${1##*.}
pref=${1%.*}

if [ $suf = "sh" ] || [ $suf = "zsh" ];then
	touch $1
	time=`date "+%Y-%m-%d %H:%M:%S"`
	echo "#!/bin/zsh" >> $1
	echo "# author:liuwenwu" >> $1
	echo "# desc:" >>$1
	echo "# create date:$time" >> $1
	chmod +x $1
elif [ $suf = "desktop" ];then
	touch $1
	echo "[Desktop Entry]" >> $1
	echo "Type=Application" >> $1
	echo "Name=$pref" >> $1
	echo "Icon=/home/liuwenwu/AppImage/.default/unknown.png" >> $1
	echo "Exec=/home/liuwenwu/AppImage/" >> $1
	echo "Terminal=false" >> $1
	echo "Categories=selfbuilt;other" >> $1
else
	touch $1
fi
