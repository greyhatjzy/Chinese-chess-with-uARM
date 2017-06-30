function   [X,Y]=transform(x,y)
%             X=round(109-27.30*y);
%             Y=round(152+20.53*x);
% %
% Y=round(21*x-1.25*abs(y-4)+144);
% y = 4 - y;
% X=round(sign(y)*(32*abs(y)-1.36*y*y));
Y=round(19/153*x+124)
X=round(22/151*y-135)

