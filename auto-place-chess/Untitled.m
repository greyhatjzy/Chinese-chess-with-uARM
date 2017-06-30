vid = videoinput('winvideo', 1, 'MJPG_2592x1944');
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;
img=getsnapshot(vid);
figure;
imshow(img)