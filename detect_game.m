%run('/Applications/MATLAB_R2015a.app/toolbox/vlfeat-0.9.20/toolbox/vl_setup.m');
run('E:/vlfeat-0.9.20-bin/vlfeat-0.9.20/toolbox/vl_setup.m');

%...................................................................
pic=getpic();
% f=ftp('192.168.111.128','jzy','hacker');
% cd(f,'ftpcamera');
% path=mget(f,'*.jpg');
% %delete(f,'webwxgetmsgimg (4).jpg') %只能删除置顶文件名的文件
% pic=imread(path{1});
% %delete(f,path{1})
% close(f)


im_board_orig_color = im2double(pic);
piece_infos = chess_state_detection(im_board_orig_color);

    %save(['Results/piece_infos_' name(1:numel(name)-4) '.mat'],'piece_infos')
%end