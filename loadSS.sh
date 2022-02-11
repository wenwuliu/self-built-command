#load self built command
commandPath=~/.self-built-command

if [ ! -e $commandPath ];then
        mkdir $commandPath
fi

autoLoad(){
        for file in `ls $1`;do
                fp=$1/$file
                suffix=`echo ${file##*.}`
                if [ -f $fp ] && ( [ $suffix = "sh" ] || [ $suffix = "zsh" ] );then
                        alias `echo ${file%.*}`=$fp
                elif [ -f $fp ] && [ $suffix = "py" ];then
                        alias `echo ${file%.*}`="python3 $fp"
                elif [ -f $fp ] && [ $suffix = "pybn" ];then
                        alias `echo ${file%.*}`=$fp
                elif [ -d $fp ];then
                        autoLoad $fp
                fi
        done
}

if [ ! -d $commandPath ];then
        echo "$commandPath is not a directory"
else
        autoLoad $commandPath
fi