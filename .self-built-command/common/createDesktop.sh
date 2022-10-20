#!/usr/bin/zsh
# author:
# desc: 创建desktop文件
# create date:2022-03-31 09:40:41
if [ $2't' = 't' ];then
	echo "createDesktop {desktopName} {executeCommand} {icon.png} {keywords}"
	echo "you can only input {desktopName} and {executeCommand} to create a desktop file"
	echo "example :"
	echo "createDesktop myapp ~/shells/test.sh ~/shells/unkown.png tools;test;"
	exit
fi

file=~/.local/share/applications/$1.desktop
touch $file
echo "[Desktop Entry]" >> $file
echo "Type=Application" >> $file
echo "Name=$1" >> $file
echo "GenericName=$1" >> $file
if [ $3't' = 't' ];then
	echo "Icon=/home/liuwenwu/AppImage/.default/unknown.png" >> $file
else
	echo "Icon=$3" >> $file
fi
echo "Exec=$2" >> $file
echo "Terminal=false" >> $file
echo "Categories=selfbuilt;other" >> $file
echo "keywords=selfbuilt;$4" >> $file
echo "built success!"
