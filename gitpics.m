%function pics=gitpics()

% obj = videoinput('winvideo', 2, 'MJPG_1024x768');
% set(obj, 'FramesPerTrigger', 1);
% set(obj, 'TriggerRepeat', Inf);
%定义一个监控界面
hf = figure('Units', 'Normalized', 'Menubar', 'None','NumberTitle', 'off', 'Name', '识别象棋');
ha = axes('Parent', hf, 'Units', 'Normalized', 'Position', [0.05 0.2 0.85 0.7]);
axis off
%定义两个按钮控件

hb1 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.25 0.05 0.2 0.1], 'String', '预览', 'Callback', ['objRes = get(obj, ''VideoResolution'');' ...
     'nBands = get(obj, ''NumberOfBands'');' ...
     'hImage = image(zeros(objRes(2), objRes(1), nBands));' ...
     'preview(obj, hImage);']);
hb2 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.55 0.05 0.2 0.1], 'String', '识别', 'Callback', ['pics=getsnapshot(obj);']);
%end
































% clear all;
% close all;
% 
% % source = aviread('live.avi');
% %source = aviread('test.avi');
% %--------------------------------------------------------------------------
% [filename, pathname] = uigetfile( ...
%    {'*.avi;*.mpg;*.mpeg;.*flv','Video Files (*.avi,*.mpg,*.mpeg,.*flv)';
%    '*.*',  'All Files (*.*)'}, ...
%   'Select a video file');
% 
% mov = mmreader(fullfile(pathname,filename));
% implay(filename);
% source = aviread(filename);
% %--------------------------------------------------------------------------
% 
% thresh = 50;
% 
% bg = source(1).cdata;           % Read in 1st frame as background frame
% bg_bw = rgb2gray(bg);           % Convert background to greyscale
% 
% % ----------------------- Set frame size variables -----------------------
% fr_size = size(bg);
% width = fr_size(2);
% height = fr_size(1);
% fg = zeros(height, width);
% 
% % --------------------- Process frames -----------------------------------
% 
% for i = 2:45
%     fr = source(i).cdata;       % Read in frame
%     fr_bw = rgb2gray(fr);       % Convert frame to grayscale
% 
%     fr_diff = abs(double(fr_bw) - double(bg_bw));  % Cast operands as double to avoid negative overflow
% 
%     for j=1:width                 % If fr_diff > thresh pixel in foreground
%         for k=1:height
%             if ((fr_diff(k,j) > thresh))
%                 fg(k,j) = fr_bw(k,j);
% 
%                 disp('motion detected');
% 
%                 %------------------------- Executes alarm ---------------------------------
% 
%                   t = 15;
%                   Fs = 50;
%                   [t,Fs] = wavread('Blip.wav');
%                   player = audioplayer(t,Fs);
%                   play(player);
% 
%                 %--------------------------------------------------------------------------
%             else
%                 fg(k,j) = 0;
%             end
%         end
%         disp('motion not detected');
%     end
% 
%     bg_bw = fr_bw;
% 
%     %figure(1), subplot(3,1,1), imshow(fr)
%     subplot(3,1,2),imshow(fr_bw)
%     subplot(3,1,3),imshow(uint8(fg))
%     figure,imshow(uint8(fr_diff))
% 
%     %M(i-1)  = im2frame(uint8(fg),gray);        % Put frames into movie
% end
% fps = 15;
% %movie2avi(M,'frame_difference_output', 'fps', 30);           % Save movie as AVI