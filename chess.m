function chess(com,piece_info)

% Constant values
nSize = 60;
nRowNum = 8; %行数
nColNum = 9; %列数
offset_x = 0.5;
offset_y = 0.5;%页边距
chess_name = {{'帥','仕','相','馬','車','炮','兵'},{'将','士','象','马','车','炮','卒'}};
chess_type = [5 4 3 2 1 2 3 4 5 6 6 7 7 7 7 7]; %棋子的布局，数字代表上面的序列
global piece_infos
global camera

% global variables
chess_x = -ones(2,16);
chess_y = -ones(2,16);
pos_chess = zeros(nRowNum+1,nColNum+1);
cur_turn = 1;
cur_cid = 0;
hText = zeros(2,16);
cur_xy=zeros(1,2);
aim_xy=zeros(1,2);
cur_xy_piece_r=zeros(1,2);
aim_xy_piece_r=zeros(1,2);
cur_xy_board_r=zeros(1,2);
aim_xy_board_r=zeros(1,2);
cur_xy_piece_b=zeros(1,2);
aim_xy_piece_b=zeros(1,2);
% cur_xy_board_b=zeros(1,2);
% aim_xy_board_b=zeros(1,2);
                
x1=0;
x2=0;
x3=0;
y1=0;
y2=0;
y3=0;
move_or_kill=0;

figure(1),hold on,axis([-offset_x nColNum+offset_x -offset_y nRowNum+offset_y]) %轴限制 前两个X，后两个Y

axis equal  % 轴的设置，可以改tight，auto，mormal 等

% axis off

set(1,'WindowButtonDownFcn',@OnWindowButtonDown);

set(1,'name','红');

InitializeChessPosition;
DrawBoard;
DrawAllChess;

%-------------------
    function DrawBoard()
        for k = 1:2
            for r = 1:nRowNum+1
                x = [(k-1)*5 4+(k-1)*5];
                y = [(r-1) (r-1)];
                plot(x,y,'b-')
            end
            for c = 1:nColNum+1
                x = [(c-1) (c-1)];
                y = [0 nRowNum];
                plot(x,y,'b-')
            end
            x = [0 2] + (k-1)*7;
            y = [3 5];
            plot(x,y,'b-')
            x = [0 2] + (k-1)*7;
            y = [5 3];
            plot(x,y,'b-')
        end
    end

%-------------------
    function DrawAllChess() %drawchess和 initialchess 都要改
        colors = 'rk';
        for k = 1:2
            for i = 1:16
                hText(k,i) = text(chess_x(k,i)-0.4,chess_y(k,i),['\fontsize{30}' chess_name{k}{chess_type(i)}],'color',colors(k));
            end
        end
    end


%-------------------
    function InitializeChessPosition()
        chess_x(:,1:9) = [zeros(1,9);9*ones(1,9)];
        chess_x(:,10:11) = [2 2;7 7];
        chess_x(:,12:16) = [3*ones(1,5); 6*ones(1,5)];
        chess_y(:,1:9) = [0:8;0:8];
        chess_y(:,10) = [1;1];
        chess_y(:,11) = [7;7];
        chess_y(:,12:16) = [0:2:8;0:2:8];
        
        pos_chess = zeros(nRowNum+1,nColNum+1);
        pos_chess(:,1) = [1:9]';
        pos_chess(:,nColNum+1) = [1:9]'+16;
        pos_chess(2,3) = 10;
        pos_chess(2,nColNum-1) = 10+16;
        pos_chess(8,3) = 11;
        pos_chess(8,nColNum-1) = 11+16;
        pos_chess(1:2:9,4) = [12:16];
        pos_chess(1:2:9,nColNum-2) = [12:16]+16;
    end

%-------------------
    function OnWindowButtonDown(src,evnt)
        
        
        %........................................red...........................
        if cur_turn == 1
            pt = get(gca,'CurrentPoint');
            x = round(pt(1,1));
            y = round(pt(1,2));
            
            play_chess_red(x,y);
            

            %change the piece_info
            
            
        end
        %........................................black.............................
        %
        %flag=motion_detection
        if cur_turn == 2
            %比较两张piece_info 得到两个（x，y）
            % ...................test .............................
            %                play_chess(9,6);
            %                play_chess(7,4);
            % ......................................................
            
           % if (input('如果已经下完，请按Y：','s') =='y')     %代替motion detection
                 pause(10); 
                 pic2=getsnapshot(camera);
              %  pic2=imread('3.jpg');
                im_board_orig_color = im2double(pic2);
                piece_infos_new = chess_state_detection(im_board_orig_color);
                
                %check the difference beteween 2 piece_info
                
                [width,high]=size( piece_infos_new);

                
                
                for i =1:width
                    for j=1:high
                        if isequal(piece_infos_new(i,j).name,piece_infos(i,j).name) %未改变的棋子
                            fprintf('0')
                        elseif (~isequal(piece_infos(i,j).name,[]))&&(isequal(piece_infos_new(i,j).name,[]))
                            x1=i
                            y1=j %chess was placed
                            [x1,y1]=piece_fig(x1,y1)
                            
                        elseif (isequal(piece_infos(i,j).name,[]))&&(~isequal(piece_infos_new(i,j).name,[]))           %move
                            x2=i
                            y2=j
                            [x2,y2]=piece_fig(x2,y2)
                        else                         %kill
                            x3=i
                            y3=j
                            [x3,y3]=piece_fig(x3,y3)
                            move_or_kill=1;
                        end
                     end
                end
                play_chess_black(x1,y1);
                if move_or_kill==1
                    play_chess_black(x3,y3)
                else
                    play_chess_black(x2,y2)
                end    
                
        end
        
        % end
    end
        
        
        
        
        
        %-------------------
        function flag = CanMove(x,y)
            flag = 1;
            oldx = chess_x(cur_turn,cur_cid);
            oldy = chess_y(cur_turn,cur_cid);
            switch chess_type(cur_cid)
                case 1% 将
                    % move 1 step
                    if ~(x==oldx && abs(y-oldy)==1) && ~(y==oldy && abs(x-oldx)==1)
                        flag = 0;
                        return
                    end
                    % out area
                    if cur_turn==1
                        if ~(x>=0 && x<=2 && y>=3 && y<=5)
                            flag = 0;
                            return
                        end
                    else
                        if ~(x>=7 && x<=9 && y>=3 && y<=5)
                            flag = 0;
                            return
                        end
                    end
                case 2% 士
                    % move 1 step
                    if ~(abs(x-oldx)==1 && abs(y-oldy)==1)
                        flag = 0;
                        return
                    end
                    % out area
                    if cur_turn==1
                        if ~(x>=0 && x<=2 && y>=3 && y<=5)
                            flag = 0;
                            return
                        end
                    else
                        if ~(x>=7 && x<=9 && y>=3 && y<=5)
                            flag = 0;
                            return
                        end
                    end
                case 3% 象
                    % move 1 step
                    if ~(abs(x-oldx)==2 && abs(y-oldy)==2)
                        flag = 0;
                        return
                    end
                    % out area
                    if cur_turn==1
                        if ~(x>=0 && x<=4)
                            flag = 0;
                            return
                        end
                    else
                        if ~(x>=5 && x<=9)
                            flag = 0;
                            return
                        end
                    end
                    % in the way
                    mx = (x+oldx)/2;
                    my = (y+oldy)/2;
                    if pos_chess(my+1,mx+1)~=0
                        flag = 0;
                        return
                    end
                case 4% 马
                    % move 1 step
                    if ~(abs(x-oldx)==1 && abs(y-oldy)==2) && ~(abs(x-oldx)==2 && abs(y-oldy)==1)
                        flag = 0;
                        return
                    end
                    % in the way
                    if abs(y-oldy)==2
                        mx = oldx;
                        my = (y+oldy)/2;
                    else
                        mx = (x+oldx)/2;
                        my = oldy;
                    end
                    if pos_chess(my+1,mx+1)~=0
                        flag = 0;
                        return
                    end
                case 5% 车
                    if ~(x==oldx && y~=oldy) && ~(x~=oldx && y==oldy)
                        flag = 0;
                        return
                    end
                    % no chess in the way
                    if x==oldx
                        inc = 1;
                        if oldy>y
                            inc = -1;
                        end
                        if ~isempty(find(pos_chess(oldy+1+inc:inc:y+1-inc,x+1)~=0))
                            flag = 0;
                            return
                        end
                    else
                        inc = 1;
                        if oldx>x
                            inc = -1;
                        end
                        if ~isempty(find(pos_chess(y+1,oldx+1+inc:inc:x+1-inc)~=0))
                            flag = 0;
                            return
                        end
                    end
                case 6% 炮
                    if ~(x==oldx && y~=oldy) && ~(x~=oldx && y==oldy)
                        flag = 0;
                        return
                    end
                    % no chess in the way
                    if x==oldx
                        inc = 1;
                        if oldy>y
                            inc = -1;
                        end
                        if pos_chess(y+1,x+1)~=0
                            if ~(length(find(pos_chess(oldy+1+inc:inc:y+1-inc,x+1)~=0))==1)
                                flag = 0;
                                return
                            end
                        else
                            if ~(isempty(find(pos_chess(oldy+1+inc:inc:y+1-inc,x+1)~=0)))
                                flag = 0;
                                return
                            end
                        end
                    else
                        inc = 1;
                        if oldx>x
                            inc = -1;
                        end
                        if pos_chess(y+1,x+1)~=0
                            if ~(length(find(pos_chess(y+1,oldx+1+inc:inc:x+1-inc)~=0))==1)
                                flag = 0;
                                return
                            end
                        else
                            if ~(isempty(find(pos_chess(y+1,oldx+1+inc:inc:x+1-inc)~=0)))
                                flag = 0;
                                return
                            end
                        end
                    end
                case 7% 兵
                    if cur_turn==1
                        if oldx<=4
                            if ~(y==oldy&&x-oldx==1)
                                flag = 0;
                                return
                            end
                        else% pass river
                            if ~(y==oldy&&x-oldx==1) && ~(abs(y-oldy)==1&&x==oldx)
                                flag = 0;
                                return
                            end
                        end
                    else
                        if oldx>=5
                            if ~(y==oldy&&x-oldx==-1)
                                flag = 0;
                                return
                            end
                        else% pass river
                            if ~(y==oldy&&x-oldx==-1) && ~(abs(y-oldy)==1&&x==oldx)
                                flag = 0;
                                return
                            end
                        end
                    end
            end
        end
        
        %-------------------
        function MoveChess(x,y)
            set(hText(cur_turn,cur_cid),'Position',[x-0.4 y]);
            pos_chess(chess_y(cur_turn,cur_cid)+1,chess_x(cur_turn,cur_cid)+1) = 0;
            pos_chess(y+1,x+1) = cur_cid+(cur_turn-1)*16;
            chess_x(cur_turn,cur_cid) = x;
            chess_y(cur_turn,cur_cid) = y;
        end
        
        %-------------------
        function KillChess(kt,kc)
            set(hText(kt,kc),'visible','off');
            MoveChess(chess_x(kt,kc),chess_y(kt,kc));
            %ChangeTurn();
            sname = {'红','黑'};
            if kc==5
                h = msgbox([sname{3-kt} '方获胜!'], '象棋', 'modal');
                %         % new game
                %         cur_turn = 1;
                %         cur_cid = 0;
                %         InitializeChessPosition;
                %         delete(hText)
                %         DrawAllChess;
            end
        end
        
        %-------------------
        function ChangeTurn()
            set(hText(cur_turn,cur_cid),'BackgroundColor','none');
            cur_turn = 3-cur_turn;
            cur_cid = 0;
            sname = {'红','黑'};
            set(1,'name',sname{cur_turn})
            % 将见帅
            if chess_y(1,5)==chess_y(2,5)
                if isempty(find(pos_chess(chess_y(1,5)+1,chess_x(1,5)+1+1:chess_x(2,5)-1+1)))
                    h = msgbox([sname{cur_turn} '方获胜!'], '象棋', 'modal');
                end
            end
        end
        
        function play_chess_red(x,y)
            %get x,y,
            
            if x<0 || x>nColNum || y<0 || y>nRowNum
                return
            end
            cc = pos_chess(y+1,x+1);   %鼠标所点的位置的棋子对应的编号
            %cur_xy=[x,y]
            if cc~=0
                ct = ceil(cc/16);     %red/bloack
                cc = mod(cc,16);      %哪一个棋子   mod 取余数
                if cc == 0
                    cc = 16;          %整除的情况
                end
            end
            
            if cur_cid==0                 %刚刚开局
                if cc~=0                  % chess clicked %此处要返回 x,y
                    if ct==cur_turn       %如果是当前的turn
                        cur_cid = cc;     %cur_cid 是当前棋子的temp
                        
                        set(hText(cur_turn,cur_cid),'BackgroundColor',[.3 .5 .1]);
                        cur_xy=[x,y]
                        
                    end
                end
            else          % have current chess          %此处要返回x,y
                if cc~=0  % chess clicked               %再次点击到棋子
                    if cc==cur_cid && ct==cur_turn      % no change
                        return
                    end
                    if ct==cur_turn                     % 换了一个棋子 %此处要返回x,y
                        set(hText(cur_turn,cur_cid),'BackgroundColor','none');
                        cur_cid = cc;
                        set(hText(cur_turn,cur_cid),'BackgroundColor',[.3 .5 .1]);
                        cur_xy=[x,y]
                        
                    else                                %吃子，此处返回X,Y
                        % kill
                        if CanMove(x,y)==1
                            KillChess(ct,cc);
                            aim_xy=[x,y]
                            [aim_xy_board_r(1),aim_xy_board_r(2)]=fig_board(aim_xy(1),aim_xy(2))
                            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',aim_xy_board_r(1),'y',aim_xy_board_r(2),'X',150,'Y',180);
                            fprintf(com,'%s',temp);
                            pause(4);
                            [cur_xy_board_r(1),cur_xy_board_r(2)]=fig_board(cur_xy(1),cur_xy(2))
                            temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',cur_xy_board_r(1),'y',cur_xy_board_r(2),'X',aim_xy_board_r(1),'Y',aim_xy_board_r(2));
                            fprintf(com,'%s',temp);
                    
                            [aim_xy_piece_r(1),aim_xy_piece_r(2)]=fig_piece(aim_xy(1),aim_xy(2))
                            [cur_xy_piece_r(1),cur_xy_piece_r(2)]=fig_piece(cur_xy(1),cur_xy(2))
                            piece_infos(aim_xy_piece_r(1),aim_xy_piece_r(2)).name=piece_infos(cur_xy_piece_r(1),cur_xy_piece_r(2)).name
                            piece_infos(cur_xy_piece_r(1),cur_xy_piece_r(2)).name=[]
                            ChangeTurn();
                        end
                        
                    end
                else                                   % no chess clicked, go there %移动 此处返回X，Y
                    if CanMove(x,y)==1
                        MoveChess(x,y);
                        aim_xy=[x,y]
                        [cur_xy_board_r(1),cur_xy_board_r(2)]=fig_board(cur_xy(1),cur_xy(2))
                        [aim_xy_board_r(1),aim_xy_board_r(2)]=fig_board(aim_xy(1),aim_xy(2))
                        temp=sprintf('%s%s%d%s%d%s%d%s%d&','a1','x',cur_xy_board_r(1),'y',cur_xy_board_r(2),'X',aim_xy_board_r(1),'Y',aim_xy_board_r(2));
                        fprintf(com,'%s',temp);
   
                        [aim_xy_piece_r(1),aim_xy_piece_r(2)]=fig_piece(aim_xy(1),aim_xy(2))
                        [cur_xy_piece_r(1),cur_xy_piece_r(2)]=fig_piece(cur_xy(1),cur_xy(2))
                        piece_infos(aim_xy_piece_r(1),aim_xy_piece_r(2)).name=piece_infos(cur_xy_piece_r(1),cur_xy_piece_r(2)).name
                        piece_infos(cur_xy_piece_r(1),cur_xy_piece_r(2)).name=[]
                        ChangeTurn();
                    end
                    
                    
                end
            end
        end
        function play_chess_black(x,y)
            %get x,y,
            
            if x<0 || x>nColNum || y<0 || y>nRowNum
                return
            end
            cc = pos_chess(y+1,x+1);   %鼠标所点的位置的棋子对应的编号
            %cur_xy=[x,y]
            if cc~=0
                ct = ceil(cc/16);     %red/bloack
                cc = mod(cc,16);      %哪一个棋子   mod 取余数
                if cc == 0
                    cc = 16;          %整除的情况
                end
            end
            
            if cur_cid==0                 %刚刚开局
                if cc~=0                  % chess clicked %此处要返回 x,y
                    if ct==cur_turn       %如果是当前的turn
                        cur_cid = cc;     %cur_cid 是当前棋子的temp
                        
                        set(hText(cur_turn,cur_cid),'BackgroundColor',[.3 .5 .1]);
                        cur_xy=[x,y]
                    end
                end
            else          % have current chess          %此处要返回x,y
                if cc~=0  % chess clicked               %再次点击到棋子
                    if cc==cur_cid && ct==cur_turn      % no change
                        return
                    end
                    if ct==cur_turn                     % change chess %此处要返回x,y
                        set(hText(cur_turn,cur_cid),'BackgroundColor','none');
                        cur_cid = cc;
                        set(hText(cur_turn,cur_cid),'BackgroundColor',[.3 .5 .1]);
                        cur_xy=[x,y]
                    else                                %吃子，此处返回X,Y
                        % kill
                        if CanMove(x,y)==1
                            KillChess(ct,cc);
                            aim_xy=[x,y]
                            [aim_xy_piece_b(1),aim_xy_piece_b(2)]=fig_piece(aim_xy(1),aim_xy(2))
                            [cur_xy_piece_b(1),cur_xy_piece_b(2)]=fig_piece(cur_xy(1),cur_xy(2))
                            
                            piece_infos(aim_xy_piece_b(1),aim_xy_piece_b(2)).name=piece_infos(cur_xy_piece_b(1),cur_xy_piece_b(2)).name
                            piece_infos(cur_xy_piece_b(1),cur_xy_piece_b(2)).name=[]
                            ChangeTurn();
                        end
                        
                    end
                else                                   % no chess clicked, go there %移动 此处返回X，Y
                    if CanMove(x,y)==1
                        MoveChess(x,y);
                        aim_xy=[x,y]
                        [aim_xy_piece_b(1),aim_xy_piece_b(2)]=fig_piece(aim_xy(1),aim_xy(2))
                        [cur_xy_piece_b(1),cur_xy_piece_b(2)]=fig_piece(cur_xy(1),cur_xy(2))
                        
                        piece_infos(aim_xy_piece_b(1),aim_xy_piece_b(2)).name=piece_infos(cur_xy_piece_b(1),cur_xy_piece_b(2)).name
                        piece_infos(cur_xy_piece_b(1),cur_xy_piece_b(2)).name=[]
                        ChangeTurn();
                    end
                    
                    
                end
            end
        end
        
        %坐标变换，figure -> piece_info
        function  [X,Y]=fig_piece(x,y)
            X=-y+9;
            Y=x+1;
        end
        
        %坐标变换，piece_info -> figure
        function   [x,y]=piece_fig(X,Y)
            x=Y-1;
            y=-X+9;
        end
        
        function   [X,Y]=fig_board(x,y)
%             X=round(109-27.30*y);
%             Y=round(152+20.53*x);
%             
            Y=round(21*x-1.25*abs(y-4)+144);
            y = 4 - y;
            X=round(sign(y)*(32*abs(y)-1.36*y*y));
            
        end
        
        
        
    end








    












%end







