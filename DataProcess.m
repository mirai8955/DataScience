%%%%%%%%%%%%ドリフト処理%%%%
    %%%%%%線形処理%%%%%%%%
    num = 2000;
    diff_data_fh = fh(end-(num-1):end,1) - fh(1:num,1);
    coef_fh = (sum(diff_data_fh)/num)/length(alldata(:,7));
%     
%     diff_data_fh = fh(num+8001:num+10000,1) - fh(1:num,1);
%     coef_fh = (sum(diff_data_fh)/num)/length(alldata(:,7));

    diff_data_fv = fv(end-(num-1):end,1) - fv(1:num,1);
    coef_fv = (sum(diff_data_fv)/num)/length(alldata(:,7));

%     diff_data_fv = fv(num+8001:num+10000,1) - fv(1:num,1);
%     coef_fv = (sum(diff_data_fv)/num)/length(alldata(:,7));

    fh_d = fh - (alldata(:,1)*(length(alldata(:,7))/alldata(end:end,1)))*coef_fh;
    fv_d = fv - (alldata(:,1)*(length(alldata(:,10))/alldata(end:end,1)))*coef_fv;

    alldata(:,7) = fh_d;
    alldata(:,10) = fv_d;

    %%%%%%ベースライン処理%%%%%%%
    alldata(:,7) = alldata(:,7) - sum(fh(1:num,1))/num;
    alldata(:,10) = alldata(:,10) - sum(fv(1:num,1))/num;

    alldata2 = alldata;
    alldata3 = alldata(1:length(alldata(:,1)),:);%時間かかるから半分に
    
    %confirmation
%     figure
%     plot(t,alldata(:,7));
%     figure
%     plot(t,alldata(:,10));
    

    %%%データ処理%%%%%
    alldata3(alldata3(:,7) < 0.05, :) = [];
    alldata3(alldata3(:,10) < 0.05, :) = [];
    alldata3(alldata3(:,6) < 30, :) = [];
    %alldata3(alldata3(:,7) > 0.6, :) = [];
    %alldata3(  alldata3(:,10) > 0.6, :) = [];
%     alldata3(alldata3(:,1) > 11, :) = [];
%     MIN_alldata = min(alldata3(:,4));
%     MAX_alldata = max(alldata3(:,4));

        %データの取りうるx軸によって値を変える(計測位置がどこからどこまでか)
    alldata3(alldata3(:,4) <= -50, :) = [];
    alldata3(alldata3(:,4) >= 45, :) =[];

%     alldata3(:,4) = alldata3(:,4) - (MIN_alldata + MAX_alldata) / 2;

    f_n = alldata3(:,7)./alldata3(:,10);
    position_n3 = alldata3(:,4);

  