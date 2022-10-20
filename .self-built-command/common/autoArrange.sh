#!/usr/bin/zsh
# author:
# desc:
# create date:2022-03-30 09:35:36
p=~/Downloads/
if [ $1't' != 't' ];then
	p=$1
fi

cd $p
dirs=("applications" "documents" "fonts" "pictures" "isos" "zips")
suf1='deb exe AppImage apk'
suf2='pdf xlsx docx xls doc ppt pptx'
suf3='ttf'
suf4='svg jpg png jpeg bmp gif'
suf5='img dmg iso'
suf6='zip rar tar.gz tar.xz jar arj'

for k in {1..${#dirs[*]}}
do
	if [ ! -d ${dirs[k]} ];then
		mkdir ${dirs[k]}
	fi
	suf=$(eval echo '$'suf${k})
	tmp=`echo $suf`
	for f in ${=tmp}
	do
		test=`mv *.$f ${dirs[k]}` > /dev/null 2>&1
	done
done

