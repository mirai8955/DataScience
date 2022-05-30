clear;
filename1 = 'Speed_Force.csv';
% filename1 = '1.5textureokamoto.csv';
% filename1 = '1.5simpleokamoto.csv';
% filename2 = '3.0simpleokamoto.csv';

n = 1;


for k = 1:n
    switch k 
        case 1 
            alldata = csvread(filename1);
        case 2 
            alldata = csvread(filename2);
    end


    %法線力、せん断力のポジショニング
    t = alldata(:,1);
    position = alldata(:,4); 
    speed = alldata(:,6);
    fh = alldata(:,7);
%     fv1 = alldata(:,8);
%     fv2 = alldata(:,9);
%     fv = fv1 + fv2;
    fv = alldata(:,10);
    
%     figure
%     plot(t,fh);
%     xlabel('時間 (s)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
%     ylabel('接線力(N)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
%     figure
%     plot(t,fv);
%     xlabel('時間 (s)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
%     ylabel('法線力(N)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
%     figure
%     plot(t,speed);
%     xlabel('時間 (s)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');
%     ylabel('速度(mm/s)','FontSize',16,'FontWeight','normal','FontName','MSゴシック');


    
    %データ処理
    run("DataProcess.m")

    %%%平均近似%%%
    
    run("AverageFitting.m")

    %separation process

    tex_part_index = zeros(10000,1);%start position and end position of texture part
    if k == 1%最初の方のデータがある10mmの範囲のところを基準にする
        threshold = 2*(sum(STD(8:18,1))/10);
    elseif k == 2
        threshold = 2*(sum(STD(1:10,1))/10);
    end
%     disp(threshold)

    
    
    
    %%%%%%case1にてせんだん力の描画、case2にて法線力の描画、case3にてCoFの描画をしている
    for l = 1:4
        switch l
            case 1
                alldata(alldata(:,7) < 0.05, :) = [];
                alldata(alldata(:,6) < 0, :) = [];
                position_n1 = alldata(:,4); 
                fh_n = alldata(:,7);
%                 figure
%                 plot(position_n1, fh_n, ".");

                %curve filttering
                %f = fit( position_n1, fh_n, 'sin8' );
                %cftool(position_n1, fh_n);                
                %plot(f, position_n1, fh_n);

            case 2
                alldata2(alldata2(:,10) < 0.05, :) = [];
                alldata2(alldata2(:,6) < 0, :) = [];
                position_n2 = alldata2(:,4); 
                fv_n = alldata2(:,10);
%                 figure
%                 plot(position_n2, fv_n, ".");
%                 curve filttering
%                 f = fit( position_n2, fv_n, 'sin8' );
%                 cftool(position_n2, fv_n);
%                 plot(f, position_n2, fv_n);

            case 3
                f_ave = fh_ave./fv_ave;

                figure
                hold on
                plot(position_n3,f_n, ".");
                plot(mPos:1:MPos+9,fn_ave,'LineWidth',2.5,'color','r');
                plot(fn_after_pos, fn_after,'.','LineWidth',2.5,'color','#EDB120');
%                 legend('Coefficient of Friction(-)','Mean Approximation','Distance from the mean','FontName','Times New Roman');
                xlabel('x (mm)','FontSize',16,'FontWeight','normal','FontName','Times New Roman');
                ylabel('Coefficient of friction(-)','FontSize',16,'FontWeight','normal','FontName','Times New Roman');
%                 ylim([-0.2 0.5]);
%                 xlim([0,75]);
                ax = gca;
                ax.FontSize = 16;
                hold off

                %curve filttering using sin function
                %f = fit( position_n3, f_n, 'sin8' );                 
                %cftool(position_n3, f_n);                
                %plot(f,"-", position_n3, f_n, ".");

            case 4

            %標準偏差出力
                
                figure
                hold on
%                 plot(fn_after_pos, fn_after,'.','color','#EDB120');
                plot(-50:1:59,STD,'-');
                yline(threshold,'r','Linewidth',1.5);
                xlim([-40 50]);
                xlabel('x (mm)','FontSize',16,'FontWeight','normal','FontName','MS明朝');
                ylabel('標準偏差(-)','FontSize',16,'FontWeight','normal','FontName','MS明朝');
                hold off

        end
    end




    %%%標準偏差からFFT求める処理%%%
    
    %一個前に計測されたデータ位置より低いデータを削除    
%     i = 2;
%     addrow = zeros(length(fn_after),1);
%     %alldata3 = [alldata3,addrow];
%     while i < length(fn_after)
%         addrow(i,1) = abs(fn_after_pos(i,1))-abs(fn_after_pos(i-1,1));
%         i = i + 1;
%     end
%     fn_ave_after = [fn_after,fn_after_pos,addrow];%平均を引く処理を施したデータとその位置の行列
%     I = find(fn_ave_after(:,3) >= 0);
%     fn_ave_after = fn_ave_after(I,:);
    %csvwrite("filename2.csv",[fn_after,fn_after_pos]);

    i = 1;
    count = 0;% finally number of tex_part_index
    bool = 0;
    while i < length(STD)%ほんとはlength(std1)だがそうするとwhile文の中のstd1(i+1,1)で存在しないindexにアクセスしてしまう
        if bool == 0 && STD(i,1) > threshold && STD(i+1,1) > threshold%2個連続thersholdより高い点を始点とする
            tex_part_index(count+1,1) = i+mPos; %start position
            bool = 1;
            count = count + 1;
        elseif bool == 1 && STD(i,1) > threshold && (STD(i+1,1) < threshold)
            tex_part_index(count+1,1) = i+mPos; %end position
            bool = 0;
            count = count + 1;
            %disp(count)
        end
        i = i + 1;
    end
    disp(tex_part_index(1:4))


   
    %%計測値の位置をめんどうだからすべてプラスにする
%     M_pos = min(fn_after_pos);
%     %disp(M_pos)
%     if M_pos < 0
%         fn_after_pos = fn_after_pos - M_pos;
%         tex_part_index = tex_part_index - M_pos;
%     end

    fn_ave_after = [fn_after,fn_after_pos,alldata3(:,1)];

   %始点と終点の位置数による調整
    count = 4;
    if count < 9999
        tex_part_index(count+1,1) = 99999;%摩擦係数として超えられない値を入れる
    else
        tex_part_index_copy = tex_part_index;
        tex_part_index = zeros(count+1,1);
        tex_part_index = tex_part_index_copy;
        tex_part_index(count+1,1) = 99999;
    end
    %csvwrite("filenae.csv",tex_part_index);
%     disp(tex_part_index(1:4,1))


    %%%%%%%%%%時間周波数を求める場合(必要のないコード)%%%%%%%%%%%

%     measure_num = length(fn_ave_after(:,2));             %number of measurement
%     i = 1;                                          % to use while function
%     l = 1;                                          % index of std1 or std2
%     j = 1;                                          %to use index of fv_std and fh_std
%     distance = 0;                                   %distance of each respectively when sliding
%     bool = 0;
%     count = 0;
%     time = zeros(10000,2);
%     
%     while i < measure_num+1
% %         if l == 3
% %             distance = distance - (tex_part_index(l,1)-tex_part_index(l-1,1));
% %         end
% 
%         if bool == 0 && tex_part_index(l,1) == 99999%擦る行程が一回終わった時
%             if fn_ave_after(i,2) < tex_part_index(l-2,1)
%                 l = 1;
%             end
%         elseif bool == 0 && fn_ave_after(i,2) >= tex_part_index(l,1)   
%             time(j,1) =  fn_ave_after(i,3);
%             bool = 1;
%             l = l + 1;
%         elseif bool == 1 && fn_ave_after(i,2) >= tex_part_index(l,1)
%             time(j,2) = fn_ave_after(i-1,3);
%             j = j + 1;
%             l = l + 1;
%             bool = 0;
%             
%             %disp(fn_ave_after(i,2))
%         end
%         i = i + 1;
%     end
%     %csvwrite("filename.csv", time)
%     %csvwrite("filename.csv",fn_tex);
%     i = 1;
%     while i < j+1 %jの数だけテクスチャがある
%         A = fn_ave_after;
%         if i == 1
%             A(A(:,3) < time(i,1),:) = [];
%             A(A(:,3) > time(i,2),:) = [];
%             fn_tex1 = [A(:,1),A(:,2),A(:,3)];
%         else
%             A(A(:,3) < time(i,1),:) = [];
%             A(A(:,3) > time(i,2),:) = [];
%             fn_tex2 = [A(:,1),A(:,2),A(:,3)];
%             fn_tex = [fn_tex1;fn_tex2];
%         end
%         i = i+1;
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%空間周波数を求める場合%%%%%%%%%%%%%%
    
    run("RemoveIntervalExecution.m");

    %一様にサンプリングされてないデータのリサンプリング
    fs = 1000;
    fntex1 = fn_tex(:,1)';
    fntex2 = fn_tex(:,2)';
    [fn_tex_rs,fp_tex_rs] = resample(fntex1, fntex2, fs);
%     fnResampled = resample(fn_tex, 0.01);
%     csvwrite("filename.csv",fn_tex);

    fn_fft = fft(fn_tex_rs);

%     figure
%     plot(fnResampled(:,1));

%     figure
%     plot(fn_tex(:,2),fn_tex(:,1));
%     xlabel('x (mm)','FontSize',16,'FontWeight','normal','FontName','MS明朝');
%     ylabel('摩擦係数(-)','FontSize',16,'FontWeight','normal','FontName','MS明朝');
%     plot(fn_tex(:,2),fn_tex(:,1), '.', fp_tex_rs, fn_tex_rs, '-');%テクスチャ部分をつなぎ合わせたもの
%     figure
%     plot( fp_tex_rs, fn_tex_rs, '.');
%     plot(fp_tex_rs, fn_tex_rs);
%     ylabel('CoF(-)','FontSize',16,'FontWeight','normal','FontName','MS明朝');
%     ylim([-0.1, 0.1]);
%     figure
%     plot(fn_fft,'.');
%     xlabel('Frequency(Hz)','FontSize',16,'FontWeight','normal','FontName','MS明朝');

fn_psd = abs(fn_fft).^2;
l = (0:1:1999) * fs / length(fn_tex_rs);
% plot(fn_psd)
% semilogy( l, fn_psd(1:2000) )
lpf_psd = lowpass( fn_psd, .001 );
% plot(l, lpf_psd(1:2000))
% figure;
% semilogy( l, lpf_psd(1:2000) )
% xlabel( "Spatial frequency (1/mm)",'FontSize',16,'FontWeight','normal','FontName','MS明朝');
% ylabel("PSD (-)",'FontSize',16,'FontWeight','normal','FontName','MS明朝');

end

