topLeftRow = 1;
topLeftCol = 1;
windowStep=65;

img=rgb2gray(imread('1.jpg'));

[bottomRightCol ,bottomRightRow,b] = size(img);                   

trainingHeight=150;   %×Ö·û¿âµÄ³¤¿í 
trainingWidth=150;


for y = topLeftCol:windowStep:bottomRightCol-trainingHeight
    for x = topLeftRow:windowStep:bottomRightRow+100-trainingHeight
    %for x = 1
        %figure;
        po = [x,y,trainingWidth,trainingHeight ];
        img2 = imcrop(img,po);
        %imshow(img2);
        
        [centers, radii, metric] = imfindcircles(img2,[50 80],'Sensitivity', 0.95);
        %viscircles(centers, radii,'EdgeColor','b');
       
       i=round((x-1)/windowStep+1)
       j=round((y-1)/windowStep+1)
       if numel(radii)
        real_centers{j,i}=[x*topLeftRow+centers(1),y*topLeftCol+centers(2)]
       end
      
    end
end
        
        
        
        
        
 





