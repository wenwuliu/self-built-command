#include"FileOperator.h"
#include<iostream>
#include<vector>
#include<string>
using namespace std;

int main(){
	string fp="/home/liuwenwu/.self-built-command/.garbage";
	FileOperator f(fp);
	string format="";
	vector<string> files;
	f.getFiles(fp,files,format);
	for(auto val:files){
		cout<<val<<endl;
	}
}
