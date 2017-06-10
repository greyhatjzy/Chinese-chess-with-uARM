function pic=getpic(IP,admin,passwd)
f=ftp(IP,admin,passwd);
cd(f,'ftpcamera');
path=mget(f,'*.jpg');

pic=imread(path{1});
delete(f,'*.jpg')
close(f)
end