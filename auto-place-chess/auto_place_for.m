topLeftRow = 1;
topLeftCol = 1;
windowStep=120;

img=rgb2gray(imread('4.5.jpg'));
%img=imread('4.5.jpg');

[bottomRightCol ,bottomRightRow,b] = size(img);

trainingHeight=200;   %×Ö·û¿âµÄ³¤¿í
trainingWidth=200;
global real_centers
global name
%....................find center..............................................
for y = topLeftCol:windowStep:bottomRightCol-trainingHeight
    for x = topLeftRow:windowStep:bottomRightRow-trainingHeight
        %for x =150
        %figure;
        po = [x,y,trainingWidth,trainingHeight ];
        img2 = imcrop(img,po);
        %imshow(img2);
        [centers, radii, metric] = imfindcircles(img2,[60 100],'Sensitivity', 0.96);
        %viscircles(centers, radii,'EdgeColor','b');
        i=round((x-1)/windowStep+1)
        j=round((y-1)/windowStep+1)
        if numel(radii)
            %real_centers2{j,i}=[x*topLeftRow+centers(1),y*topLeftCol+centers(2)];
            real_centers=[real_centers [x*topLeftRow+centers(1); y*topLeftCol+centers(2)]];
        end
        
    end
end

........................kmeans........................................
    [idx,C]=kmeans(real_centers',32)
figure;
imshow(img)
[w,h]=size(C);
hold on
for i =1:w
    
    plot(C(i,1),C(i,2),'o','MarkerFaceColor','g','LineWidth',2, 'MarkerSize',8)
    piece=img(C(i,2)-80:C(i,2)+80,C(i,1)-80:C(i,1)+80);
    name{i}=char_recognition(piece)
    
end

%...................................................................


