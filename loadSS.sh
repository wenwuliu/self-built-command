#load self built command
alias sudo="sudo "

selfBuiltPath=~/.self-built-command

loadSHFile(){
	for file in `ls $1`;do
		fp=$1/$file
		suf=${file##*.}
		if [ -f $fp ] && ( [ $suf = "sh" ] || [ $suf = "zsh" ] );then
			alias ${file%.*}=$fp
		elif [ -d $fp ];then
			loadSHFile $fp
		fi
	done

}

if [ ! -e $selfBuiltPath ];then
	mkdir $selfBuiltPath
elif [ -f $selfBuiltPath ];then
	echo "$selfBuiltPath should be a directory"
fi

loadSHFile $selfBuiltPath
