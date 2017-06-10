function piece_infos = chess_state_detection(im_board_orig_color)
    %if nargin == 0
    %    run('/Applications/MATLAB_R2015a.app/toolbox/vlfeat-0.9.20/toolbox/vl_setup.m');
    %     im_board_orig_color = imresize(im2double(imread('Database/view_1.jpg')),1);
    %   %为什么要resize,而且是放大一倍
    %end
    
    im_board_golden_color = im2double(imread('board_empty_golden.jpg'));
    %归一化 在[0,1]之间，
    im_board_golden = rgb2gray(im_board_golden_color);
    %彩色转为灰色
   
    %figure;  %figure1
    %imshow(im_board_orig_color);
 
    im_board_top_down = transform_board(im_board_orig_color, im_board_golden);%棋盘矫正
   
    %显示部分，可删
    %figure;
    %imshow(0.5*(im_board_top_down+im_board_golden_color));

    piece_infos = char_recognition(im_board_top_down);%棋子识别
 
    %piece_infos = color_recognition(piece_infos);%颜色识别
%     piece_infos = [];
end