function name = char_recognition(pic)

%figure;

refs=load('chess_piece_refs.mat');
refs = refs.chess_piece_refs;
        match_max = 0;
        for refs_key_cell = refs.keys;
            refs_key = refs_key_cell{1};
            im_ref = refs(refs_key);
            sift_result = sift_match(im_ref, pic);
            if sift_result.ransac > match_max
                match_max = sift_result.ransac;
                match_key = refs_key;
                
            end
        end
        
        
        if match_max > 0
            name = match_key;
            
        else
            name = 'none';
            
        end

end
