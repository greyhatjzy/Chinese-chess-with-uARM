% %...................Camera Initial .........................................
global camera
camera = videoinput('winvideo', 2, 'MJPG_1600x1200');
set(camera, 'FramesPerTrigger', 10);
set(camera, 'TriggerRepeat', Inf); 
pause(3)

%.........................get pic and recognize ............................
%pic1=getpics_usb(camera);
pic1=getsnapshot(camera);

% pic1=imread('1.jpg');
im_board_orig_color = im2double(pic1);
global piece_infos;
piece_infos = chess_state_detection(im_board_orig_color);
%....................Play chess............................................
%checkpiceinfo if not ,then initial
result=1;
    if result==1
    com=serial('COM3','baudrate',115200,'parity','none','databits',8,'stopbits',1);
    fopen(com);
    chess(com,piece_infos);
    %chess(piece_infos);
    else
    piece_infos
    end
