    MinPos = -50;%計測時の最小の位置
    MaxPos = 50;%計測時の最大の位置
    PosForIndex = -(MinPos-1);%計測時の最小の位置の分だけindexを±する
    pos = MinPos;
    m = 0;
    STD = zeros(110,1);
    CoF_ave = zeros(110,1);%1mmごとの位置に対する摩擦係数の平均fd
    CoF_Averaged = ALLDATA_CLEAN(:,7)./ALLDATA_CLEAN(:,10);%平均を引く処理をした後のデータの摩擦係数
    CoF_Averaged_pos = ALLDATA_CLEAN(:,4);%平均を引く処理をした後のデータの位置

    while pos<MaxPos
        %%%%%%%%%%%%せんだん力%%%%%%%%%%%%%%%
        fh_avepos = ALLDATA_CLEAN;
        fh_avepos(fh_avepos(:,4) <= pos, :) = [];%1mm範囲外のデータ消去
        fh_avepos(fh_avepos(:,4) > pos+1, :) = [];
        ave_pos = fh_avepos(:,7);
        fh_ave = sum(ave_pos)/length(ave_pos);%i~i+1の区間のせん断力の摩擦係数の平均を計算

        %confirmation
%         ave_pos = ave_pos.';
%         if pos == 0
%             csvwrite('filename.csv', ave_pos);
%         else
%             dlmwrite( 'filename.csv', ave_pos, '-append');
%         end

        %%%%%%%%%%%%法線力%%%%%%%%%%%%%%%%%%
        fv_avepos = ALLDATA_CLEAN;
        fv_avepos(fv_avepos(:,4) <= pos, :) = [];%1mm範囲外のデータ消去
        fv_avepos(fv_avepos(:,4) > pos+1, :) = [];
        ave_pos = fv_avepos(:,10);
        fv_ave = sum(ave_pos)/length(ave_pos);
%         disp(fv_ave)
        
        CoF_ave(m+1,1) = fh_ave./fv_ave;
        CoF_tem = fh_avepos(:,7)./fv_avepos(:,10) - CoF_ave(m+1,1);
        
        %%%標準偏差
        STD(m+1,1) = std(CoF_tem);
        %disp(length(std1));
        
        pos = pos+1;
        m = m+1;
    end
%     disp(STD)
    datasize = length(ALLDATA_CLEAN(:,1));
    i = 1;

    while i < datasize
        %元データから平均を引く
        CoF_Averaged(i,1) = CoF_Averaged(i,1) - CoF_ave(floor(CoF_Averaged_pos(i,1))+PosForIndex,1);%fn_after_posの整数部分をaとして，fn_afterのpositionをa+1とする

        %元データから平均を引く
%         CoF_ave = fh_avepos(:,7)./fv_avepos(:,10);
%         CoF_tem = CoF_ave - fh_ave(i,1)./fv_ave(i,1);
%         %if isnan(fn)
%         CoF_Averaged(j,1) = CoF_tem;
%         CoF_Averaged_pos(j,1) = fh_avepos(:,4);%別にfvでもよい
%         %end
%         CoF_Averaged = [CoF_Averaged;CoF_tem];
%         CoF_Averaged_pos = [CoF_Averaged_pos;fv_avepos(:,4)];

        %%%%元のやつ%%%%%
        %row = find(i <= ALLDATA_CLEAN(:,4) && ALLDATA_CLEAN(:,4)< i+1);
        %fh_position = ALLDATA_CLEAN(row,7);
        %fh_ave(i+1,1) = sum(fh_position)/length(fh_position);

        i = i+1;
        
    end