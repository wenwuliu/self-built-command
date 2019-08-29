#include"FileOperator.h"

FileOperator::FileOperator(){
}

FileOperator::FileOperator(std::string path){
	this->path = path;
}

void FileOperator::getFiles(std::string path,std::vector<std::string>&files,std::string format){
	if("" == path){
		std::cout<< "path is null"<<std::endl;
		return;
	}
	if( !this->isExist(path)){
		std::cout<<"file not exist"<<std::endl;
		return;
	}
	struct dirent * file;
	DIR * dir;
	const char* p = path.data();
	dir=opendir(p);
	while((file=readdir(dir)) != NULL){
		if(file->d_name[0] == '.')
			continue;
		std::string fn=file->d_name;
		std::string::size_type begin;
		if((begin=fn.find(format)) != std::string::npos){
			switch(file->d_type){
				case DT_DIR:{
				    		files.push_back(fn);
						this->getFiles(path.append("/").append(fn),files,format);
						break;
					    } 
				case DT_REG:{
					    	files.push_back(fn);
						break;
					    }
				default:{
					//pass
					}
			}
		}
	}
	closedir(dir);

}

bool FileOperator::isExist(std::string path){
	DIR * dir;
	const char*p = path.data();
	dir = opendir(p);
	if( NULL == dir ){
		closedir(dir);
		return false;
	}
	closedir(dir);
	return true;
}
