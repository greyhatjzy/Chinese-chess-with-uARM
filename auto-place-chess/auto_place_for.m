topLeftRow = 1;
topLeftCol = 1;
windowStep=100;


vid = videoinput('winvideo', 1, 'MJPG_2592x1944');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;

img=getsnapshot(vid);

img=img(80:1850,350:2150);
figure;
imshow(img)
[bottomRightCol ,bottomRightRow,b] = size(img);

trainingHeight=180;   %×Ö·û¿âµÄ³¤¿í
trainingWidth=180;
global real_centers
global name
%....................find center..............................................
for y = topLeftCol:windowStep:bottomRightCol-trainingHeight
    for x = topLeftRow:windowStep:bottomRightRow-trainingHeight
        %for x =150
        %figure;
        po = [x,y,trainingWidth,trainingHeight ];
        img2 = imcrop(img,po);
        % imshow(img2);
        [centers, radii, metric] = imfindcircles(img2,[60 120],'Sensitivity', 0.96);
        %viscircles(centers, radii,'EdgeColor','b');
        i=round((x-1)/windowStep+1)
        j=round((y-1)/windowStep+1)
        if numel(radii)
            %real_centers2{j,i}=[x*topLeftRow+centers(1),y*topLeftCol+centers(2)];
            real_centers=[real_centers [x+centers(1); y+centers(2)]];
        end
        
    end
end

........................kmeans........................................
    com=serial('COM3','baudrate',115200,'parity','none','databits',8,'stopbits',1);

fopen(com);

[idx,C]=kmeans(real_centers',16)
figure;
imshow(img)
[w,h]=size(C);
hold on
num1=1;
num2=1;
num3=1;
num4=1;
num5=1;
num6=5

for i =1:w
    plot(C(i,1),C(i,2),'o','MarkerFaceColor','g','LineWidth',2, 'MarkerSize',8)
    piece=img(C(i,2)-80:C(i,2)+80,C(i,1)-80:C(i,1)+80);
    %figure;
    % imshow(piece)
    name{i}=char_recognition(piece)
    pause(1)
    [X,Y]=transform(C(i,1),C(i,2))
    
    if isequal(name{i}, 'b_general')
        temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',0,'Y',145);
        fprintf(com,'%s',temp);
        pause(5)
    elseif isequal(name{i},'b_chariot')
        if num1
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',110,'Y',145);
            num1=num1-1;
        else
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',-110,'Y',145);
        end
        fprintf(com,'%s',temp);
        pause(5)
    elseif isequal(name{i},'b_horse')
        if num2
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',85,'Y',145);
            num2=num2-1;
        else
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',-85,'Y',145);
        end
        fprintf(com,'%s',temp);
        pause(5)
    elseif isequal(name{i},'b_elephant')
        if num3
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',60,'Y',145);
            num3=num3-1;
        else
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',-60,'Y',145);
        end
        fprintf(com,'%s',temp);
        pause(5)
        
    elseif isequal(name{i},'b_advisor')
        if num4
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',30,'Y',145);
            num4=num4-1;
        else
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',-30,'Y',145);
        end
        fprintf(com,'%s',temp);
        pause(5)
    elseif isequal(name{i},'b_cannon')
        if num5
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',83,'Y',185);
            num5=num5-1;
        else
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',-83,'Y',185);
        end
        fprintf(com,'%s',temp);
        pause(5)
    elseif isequal(name{i}, 'b_solider')
        if num6==5
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',105,'Y',205);
            num6=num6-1;
        elseif  num6==4
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',55,'Y',205);
            num6=num6-1;
        elseif  num6==3
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',0,'Y',205);
            num6=num6-1;
        elseif  num6==2
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',-60,'Y',205);
            num6=num6-1;
        elseif  num6==1
            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',X,'y',Y,'X',-110,'Y',205);
        end   
        fprintf(com,'%s',temp);
        pause(5)
        
        
    end
    
    
    
    
    
    
    
end

