measure_num = length(fn_ave_after(:,2));             %number of measurement
    i = 1;                                          % to use while function
    l = 1;                                          % index of std1 or std2
    j = 1;                                          %to use index of fv_std and fh_std
    distance = 0;                                   %distance of each respectively when sliding
    Spoint1 = 0; Spoint2 = 0;
    Fpoint1 = 0; Fpoint2 = 0;
    bool = 0;
    fn_tex = zeros(10000,2);
    count = 0;
    time = zeros(10000,1);
    bet23 = tex_part_index(3,1) - tex_part_index(2,1);
    bet12 = ( tex_part_index(4,1) - tex_part_index(3,1) );
    
    while i < measure_num+1
%         if l == 3
%             distance = distance - (tex_part_index(l,1)-tex_part_index(l-1,1));
%         end

        if bool == 0 && tex_part_index(l,1) == 99999%擦る行程が一回終わった時
            if fn_ave_after(i,2) < tex_part_index(l-2,1)
                l = 1;
                distance = distance + (Fpoint1 - Spoint1) + (Fpoint2 - Spoint2) + 0.1;%同じ位置上に2点あるといけないから+0.1
                %distance = distance + (fn_ave_after(i-1,2)-(tex_part_index(3,1) - tex_part_index(2,1) + tex_part_index(1,1)));%一個前のループでtex_part_index(l,1)==99999となったからi-1,　テクスチャの間や最初のテクスチャが始まる位置を引く
                count = count + 1;
                %disp(fn_ave_after(i-1,2))
            end
        elseif bool == 0 && fn_ave_after(i,2) >= tex_part_index(l,1)%%%始点を超えた瞬間
%             disp(tex_part_index(l,1))            
            bool = 1;
            fn_tex(j,1) = fn_ave_after(i,1);
            if l == 1
                Spoint1 = fn_ave_after(i,2);
                fn_tex(j,2) = fn_ave_after(i,2) - Spoint1 + distance;
                %disp(fn_ave_after(i,2))
            else
                distance = distance + 0.1;
                Spoint2 = fn_ave_after(i,2);
%                 disp(fn_ave_after(i,2))
                fn_tex(j,2) = fn_ave_after(i,2) - Spoint1 - (Spoint2 - Fpoint1) + distance;
            end
            j = j + 1;
            l = l + 1;
        elseif bool == 1 && fn_ave_after(i,2) < tex_part_index(l,1)%%%始点と終点の間
            fn_tex(j,1) = fn_ave_after(i,1);
            if l == 2
                fn_tex(j,2) = fn_ave_after(i,2) - Spoint1 + distance;
            else
                fn_tex(j,2) = fn_ave_after(i,2) - Spoint1 - (Spoint2 - Fpoint1) + distance;
            end
            j = j + 1;
        elseif bool == 1 && fn_ave_after(i,2) >= tex_part_index(l,1)%%%%終点を超えた瞬間
            if l ==2 
                Fpoint1 = fn_ave_after(i,2);
%                 disp(fn_ave_after(i-1,2))
            else 
                Fpoint2 = fn_ave_after(i,2);
            end
            l = l + 1;
            bool = 0;     
        end
        i = i + 1;
    end
%     disp(count)
    fn_tex(fn_tex(:,1)==0,:) = [];% eliminate extra zeros
%     csvwrite("filename.csv",fn_tex)
%     disp(fh_tex)