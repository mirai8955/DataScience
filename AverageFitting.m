%div1 = length(f_n);
    mPos = -50;%計測時の最小の位置
    MPos = 50;%計測時の最大の位置
    pIndex = -(mPos-1);%計測時の最小の位置の分だけindexを±する
    i = mPos;
    j = 1;
    m = 0;
    STD = zeros(110,1);
    fn_ave = zeros(110,1);%1mmごとの位置に対する摩擦係数の平均
    ave_pos = alldata3(:,4);
    fn_after = alldata3(:,7)./alldata3(:,10);%平均を引く処理をした後のデータの摩擦係数
    fn_after_pos = alldata3(:,4);%平均を引く処理をした後のデータの位置

    while i<MPos
        %%%%%%%%%%%%せんだん力%%%%%%%%%%%%%%%
        fh_avepos = alldata3;
        fh_avepos(fh_avepos(:,4) <= i, :) = [];%1mm範囲外のデータ消去
        fh_avepos(fh_avepos(:,4) > i+1, :) = [];
        ave_pos = fh_avepos(:,7);
        fh_ave = sum(ave_pos)/length(ave_pos);%i~i+1の区間のせん断力の摩擦係数の平均を計算

        %confirmation
%         ave_pos = ave_pos.';
%         if i == 0
%             csvwrite('filename.csv', ave_pos);
%         else
%             dlmwrite( 'filename.csv', ave_pos, '-append');
%         end

        %%%%%%%%%%%%法線力%%%%%%%%%%%%%%%%%%
        fv_avepos = alldata3;
        fv_avepos(fv_avepos(:,4) <= i, :) = [];%1mm範囲外のデータ消去
        fv_avepos(fv_avepos(:,4) > i+1, :) = [];
        ave_pos = fv_avepos(:,10);
        fv_ave = sum(ave_pos)/length(ave_pos);
        
        fn_ave(j,1) = fh_ave./fv_ave;
        fn_tem = fh_avepos(:,7)./fv_avepos(:,10) - fn_ave(j,1);
        
        %%%標準偏差
        STD(m+1,1) = std(fn_tem);
        %disp(length(std1));
        
        i = i+1;
        j = j+1;
        m = m+1;
    end
%     disp(STD)
    datasize = length(alldata3(:,1));
    i = 1;

    while i < datasize
        %元データから平均を引く
        fn_after(i,1) = fn_after(i,1) - fn_ave(floor(fn_after_pos(i,1))+pIndex,1);%fn_after_posの整数部分をaとして，fn_afterのpositionをa+1とする

        %元データから平均を引く
%         fn_ave = fh_avepos(:,7)./fv_avepos(:,10);
%         fn_tem = fn_ave - fh_ave(i,1)./fv_ave(i,1);
%         %if isnan(fn)
%         fn_after(j,1) = fn_tem;
%         fn_after_pos(j,1) = fh_avepos(:,4);%別にfvでもよい
%         %end
%         fn_after = [fn_after;fn_tem];
%         fn_after_pos = [fn_after_pos;fv_avepos(:,4)];

        %%%%元のやつ%%%%%
        %row = find(i <= alldata3(:,4) && alldata3(:,4)< i+1);
        %fh_position = alldata3(row,7);
        %fh_ave(i+1,1) = sum(fh_position)/length(fh_position);

        i = i+1;
        
    end