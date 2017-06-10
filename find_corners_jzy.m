%find corners
I=imread('corner_test.png');
[height, width] = size(I);
thresh = graythresh(I);
I = im2bw(I, thresh);
se = strel('disk', fix(height/5000), 4);
I = imdilate(I, se);
corners = detectHarrisFeatures(I);
%corners = detectMinEigenFeatures(I);
imshow(I); hold on;
plot(corners.selectStrongest(100));
