#include"FileOperator.h"
#include<string>
#include<iostream>
#include<cstring>
#include<vector>
#include<stdlib.h>
using namespace std;

/**
 *desc: garbage [-h help -l list files -c clear garbage -d {args} delete target file]
 *
 **/
void help(){
	cout<<"garbage:related to delete command,manage your garbages"<<endl;
	cout<<"param:["<<endl;
	cout<<"-h {help} -l {list file} -c {clear garbage} -r args {restore target file}"<<endl;
	cout<<"]"<<endl;
}

int main(int argc,char *argv[]){
	if(argc == 1){
		help();
	}
	char h[5]="-h";
	char l[5]="-l";
	char c[5]="-c";
	char d[5]="-d";
	if(argc == 2){
		string fp="/home/liuwenwu/.self-built-command/.garbage";
		char *param = argv[1];
		if(strcmp(argv[1],h) == 0){
		//help
			help();
		}else if(strcmp(argv[1],l) == 0){
		// list
			FileOperator f(fp);
			string format="";
			vector<string> files;
			f.getFiles(fp,files,format);
			for(auto val:files){
				string filename = val.substr(0,val.length() - 8);
				cout<<filename<<endl;
			}
			
		}else if(strcmp(argv[1],c) == 0){
		//clear
			string removeFiles = "rm -rf "+ fp;
			const char* const_file_char = removeFiles.c_str();
			char* file_char = const_cast<char*>(const_file_char);
			int i = system(file_char);
			if(i == -1 || i == 127){
				cout<<"execute failed! err code:" + i<<endl;
			}
		}else{
			help();
		}
	}

	char c[5] = "-r";
	//other:must start with -r  restore files
	if(strcmp(argv[1],c) == 0){
		for()
	}else{
		help();
	}
	
}
