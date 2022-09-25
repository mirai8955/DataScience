clear;
filename1 = '../1.5textureokamoto.csv';
% filename1 = '../1.5textureokamoto.csv';
% filename1 = '../1.5simpleokamoto.csv';
% filename2 = '../3.0simpleokamoto.csv';

n = 1;


for k = 1:n
    switch k 
        case 1 
            ALLDATA = csvread(filename1);
        case 2 
            ALLDATA = csvread(filename2);
    end


    %列のデータ種類(ただのコメント)
%     t = ALLDATA(:,1);
%     position = ALLDATA(:,4); 
%     speed = ALLDATA(:,6);
%     fh = ALLDATA(:,7);
%     fv = ALLDATA(:,10);
    
    %元のデータを可視化
    %figuremake(ALLDATA, "timebaseoriginal")
    
    %データ処理
    run("DataProcess.m")

    %%%平均近似%%%
    run("AverageFitting.m")

    %せんだん力
    %figuremake(ALLDATA,"shearforce")

    %法線力
    %figuremake(ALLDATA,"verticalforce")

    %CoFの描画

%     figure
%     hold on
%     plot(position_n3,CoF, ".");
%     plot(MinPos:1:MaxPos+9,CoF_ave,'LineWidth',2.5,'color','r');
%     plot(CoF_Averaged_pos, CoF_Averaged,'.','LineWidth',2.5,'color','#EDB120');
%     %legend('Coefficient of Friction(-)','Mean Approximation','Distance from the mean','FontName','Times New Roman');
%     xlabel('x (mm)','FontSize',16,'FontWeight','normal','FontName','Times New Roman');
%     ylabel('Coefficient of friction(-)','FontSize',16,'FontWeight','normal','FontName','Times New Roman');
%     %ylim([-0.2 0.5]);
%     %xlim([0,75]);
%     ax = gca;
%     ax.FontSize = 16;
%     hold off

    %標準偏差出力
    if k == 1%最初の方のデータがある10mmの範囲のところを基準にする
        threshold = 2*(sum(STD(50:60,1))/10);
    elseif k == 2
        threshold = 2*(sum(STD(0:10,1))/10);
    end
    disp(threshold)
                
    figure
    hold on
    %plot(CoF_Averaged_pos, CoF_Averaged,'.','color','#EDB120');
    plot(-50:1:59,STD,'-');
    yline(threshold,'r','Linewidth',1.5);
    xlim([-40 50]);
    xlabel('x (mm)','FontSize',16,'FontWeight','normal','FontName','MS明朝');
    ylabel('標準偏差(-)','FontSize',16,'FontWeight','normal','FontName','MS明朝');
    hold off

    
    %どの位置にテクスチャが存在しているか
    tex_part_index = zeros(10000,1);%start position and end position of texture part
    i = 1;
    count = 0;% finall number of tex_part_index
    bool = 0;
    while i < length(STD)%ほんとはlength(std1)だがそうするとwhile文の中のstd1(i+1,1)で存在しないindexにアクセスしてしまう
        if bool == 0 && STD(i,1) > threshold && STD(i+1,1) > threshold%2個連続thersholdより高い点を始点とする
            tex_part_index(count+1,1) = i+MinPos; %start position
            bool = 1;
            count = count + 1;
        elseif bool == 1 && STD(i,1) > threshold && (STD(i+1,1) < threshold)
            tex_part_index(count+1,1) = i+MinPos; %end position
            bool = 0;
            count = count + 1;
            %disp(count)
        end
        i = i + 1;
    end
    disp(tex_part_index(1:4))

    fn_ave_after = [CoF_Averaged,CoF_Averaged_pos,ALLDATA_CLEAN(:,1)];

   %始点と終点の位置数による調整
    count = 4;
    if count < 9999
        tex_part_index(count+1,1) = 99999;%摩擦係数として超えられない値を入れる
    else
        tex_part_index_copy = tex_part_index;
        tex_part_index = tex_part_index_copy;
        tex_part_index(count+1,1) = 99999;
    end
    %csvwrite("filenae.csv",tex_part_index);
%     disp(tex_part_index(1:4,1))


    %%%%%%%%%空間周波数を求める場合%%%%%%%%%%%%%%
    
    %触察時以外の取得データ削除
    run("RemoveIntervalExecution.m");

    %一様にサンプリングされてないデータのリサンプリング
    fs = 1000;
    fntex1 = fn_tex(:,1)';
    fntex2 = fn_tex(:,2)';
    [fn_tex_rs,fp_tex_rs] = resample(fntex1, fntex2, fs);
%     fnResampled = resample(fn_tex, 0.01);
%     csvwrite("filename.csv",fn_tex);

    fn_fft = fft(fn_tex_rs);

fn_psd = abs(fn_fft).^2;
l = (0:1:1999) * fs / length(fn_tex_rs);
% plot(fn_psd)
% semilogy( l, fn_psd(1:2000) )
lpf_psd = lowpass( fn_psd, .001 );
% plot(l, lpf_psd(1:2000))
figure;
semilogy( l, lpf_psd(1:2000) )
xlabel( "Spatial frequency (1/mm)",'FontSize',16,'FontWeight','normal','FontName','MS明朝');
ylabel("PSD (-)",'FontSize',16,'FontWeight','normal','FontName','MS明朝');

end



%%%%%%%%%%%%%%%%%%%関数定義%%%%%%%%%%%%%%%%%%%%%%%
function figuremake(DATA,TYPE)
    if TYPE == "timeoriginal"
        figure
        plot(DATA(:,1),DATA(:,7));
        xlabel('時間 (s)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
        ylabel('接線力(N)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
        figure
        plot(DATA(:,1),DATA(:,10));
        xlabel('時間 (s)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
        ylabel('法線力(N)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
        figure
        plot(DATA(:,1),DATA(:,6));
        xlabel('時間 (s)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
        ylabel('速度(mm/s)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
    end

    if TYPE == "shearforce"
        DATA(DATA(:,7) < 0.05, :) = [];
        DATA(DATA(:,6) < 0, :) = [];
        figure
        plot(DATA(:,4), DATA(:,7), ".");
    end

    if TYPE == "verticalforce"
        DATA(DATA(:,10) < 0.05, :) = [];
        DATA(DATA(:,6) < 0, :) = [];
        figure
        plot(DATA(:,4), DATA(:,10), ".");
    end
    
end

