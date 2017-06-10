function pic=getpic();
f=ftp('192.168.137.99','pi','raspberry');
cd(f,'ftpcamera');
path=mget(f,'*.jpg');
%delete(f,'webwxgetmsgimg (4).jpg') %只能删除置顶文件名的文件
pic=imread(path{1});
%delete(f,path{1})
close(f)
end