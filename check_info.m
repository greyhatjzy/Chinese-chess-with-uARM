function result=check_info(piece_infos)
  standardize= load('chess_initial.mat');
  standardize=standardize.piece_infos;
  [weight,hight]=size(piece_infos);
  for i=1:weight
     for j=1:hight
         if strcmp(piece_infos(i,j).name,standardize(i,j).name)
             if strcmp(piece_infos(i,j).color,standardize(i,j).color)
                 result=1;
             else
                 result=0;
             end
         else
             result=0;
         end    
     end 
  end    
     




end