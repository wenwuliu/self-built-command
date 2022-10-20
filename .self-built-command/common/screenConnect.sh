#!/usr/bin/zsh
# author:
# desc:
# create date:2022-04-18 17:09:06
if [ $1't' = 't' ] || [ $1't' = 'helpt' ];then
	echo "screenConnect show:show all screen device"
	echo "screenConnect on deviceName:connect to deviceName"
	echo "screenConnect off deviceName:disconnect from deviceName"
	exit
fi

if [ $1't' = 'ont' ];then
	xrandr --output $2 --right-of eDP-1 --auto
	exit
fi
if [ $1't' = 'offt' ];then
	xrandr --output $2 --off
	exit
fi

if [ $1't' = 'showt' ];then
	xrandr
	exit
fi

