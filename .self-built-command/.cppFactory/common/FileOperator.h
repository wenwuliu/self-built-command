#include<string>
#include<vector>
#include<dirent.h>
#include<iostream>
#include<stdlib.h>
#include<sys/stat.h>
#include<unistd.h>
#ifndef FILEOPERATOR_H
#define FILEOPERATOR_H
class FileOperator{
	private:
		std::string path;
	public:
		FileOperator();
		FileOperator(std::string path);
		void getFiles(std::string path,std::vector<std::string>&files,std::string format);
		bool isExist(std::string path);
};

#endif
