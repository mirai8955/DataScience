%%%%%%%%%%%%ドリフト処理%%%%
    fh = ALLDATA(:,7);
    fv = ALLDATA(:,10);
    NUMBER = 2000;

    %%%%%%ベースライン処理%%%%%%%
    ALLDATA(:,7) = ALLDATA(:,7) - sum(fh(1:NUMBER,1))/NUMBER;
    ALLDATA(:,10) = ALLDATA(:,10) - sum(fv(1:NUMBER,1))/NUMBER;

    %%%%%%線形処理%%%%%%%%
    diff_data_fh = fh(end-(NUMBER-1):end,1) - fh(1:NUMBER,1);
    coef_fh = (sum(diff_data_fh)/NUMBER)/length(ALLDATA(:,7));

    diff_data_fv = fv(end-(NUMBER-1):end,1) - fv(1:NUMBER,1);
    coef_fv = (sum(diff_data_fv)/NUMBER)/length(ALLDATA(:,7));

    ALLDATA(:,7) = fh - (ALLDATA(:,1)*(length(ALLDATA(:,7))/ALLDATA(end:end,1)))*coef_fh;
    ALLDATA(:,10) = fv - (ALLDATA(:,1)*(length(ALLDATA(:,10))/ALLDATA(end:end,1)))*coef_fv;
    
    %処理後のデータ
    ALLDATA_CLEAN = ALLDATA;%時間かかるから半分に
    
    %confirmation
%     figure
%     plot(t,ALLDATA(:,7));
%     figure
%     plot(t,ALLDATA(:,10));
    

    %%%データ処理%%%%%
    ALLDATA_CLEAN(ALLDATA_CLEAN(:,7) < 0.05, :) = [];
    ALLDATA_CLEAN(ALLDATA_CLEAN(:,10) < 0.05, :) = [];
    ALLDATA_CLEAN(ALLDATA_CLEAN(:,6) < 30, :) = [];
    %ALLDATA_CLEAN(ALLDATA_CLEAN(:,7) > 0.6, :) = [];
    %ALLDATA_CLEAN(  ALLDATA_CLEAN(:,10) > 0.6, :) = [];
%     ALLDATA_CLEAN(ALLDATA_CLEAN(:,1) > 11, :) = [];
%     MIN_alldata = min(ALLDATA_CLEAN(:,4));
%     MAX_alldata = max(ALLDATA_CLEAN(:,4));

        %データの取りうるx軸によって値を変える(計測位置がどこからどこまでか)
    ALLDATA_CLEAN(ALLDATA_CLEAN(:,4) <= -50, :) = [];
    ALLDATA_CLEAN(ALLDATA_CLEAN(:,4) >= 45, :) =[];

%     ALLDATA_CLEAN(:,4) = ALLDATA_CLEAN(:,4) - (MIN_alldata + MAX_alldata) / 2;

    CoF = ALLDATA_CLEAN(:,7)./ALLDATA_CLEAN(:,10);
    position_n3 = ALLDATA_CLEAN(:,4);

  