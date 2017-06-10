I=imread('1.jpg');%  提取图像
[height,width]=size(I);
%I=rgb2gray(I);
thresh=graythresh(I);
I_bw=im2bw(I,thresh);
%BW1=edge(I,'sobel'); %用SOBEL算子进行边缘检测
%BW2=edge(I,'roberts');%用Roberts算子进行边缘检测
%BW3=edge(I,'prewitt'); %用prewitt算子进行边缘检测
%BW4=edge(I,'log'); %用log算子进行边缘检测
%BW5=edge(I,'canny'); %用canny算子进行边缘检测
%se=strel('disk',fix(height/500),4);  腐蚀
%I_bw=imerode(I_bw,se);


%I_bw=imfill(I_bw,'holes');


se = strel('disk', fix(height/500), 4);
I_bw = imdilate(I_bw, se);

STATS=regionprops(I_bw,'Area','Centroid','BoundingBox');
area=cat(10,STATS.Area);
I_bw=bwareaopen(I_bw,fix(max(area(:)*0.1)));
I_bw=imfill(I_bw,'holes');


