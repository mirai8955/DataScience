
%%one
% a = [6, 7, 1, 8, 2;2, 3, 5, 6, 8];
% k = a(a(1,:)< 5);
% b= find(k<5);
% disp(b);
% c = a(1,b);
% disp(c);

%%two ベクトルは拡張できるのか
% t = zeros(1,1);
% i=0;
% while i<5
%     t(i,1)=5;
% end
% disp(t);
%結論；最初に行列を作成しとたほうが良い

%%three if文にisnan()を使った時の動作確認
% i = 0;
% A = 0./[-2 -1 0 1 2];
% B = zeros(0,1);
% while i<5
%     %T = isnan(A(1,i+1));
%     if islogical(isempty(B))
%         continue
%     end
%     
%     disp(i)
%     i = i+1;
% end
%結論：うまくいかない

%%four 行列のある一列をソートした時にそのソートを他の列にも反映させる
% A = randi(15,5);
% disp(A)
% I = find(A(:,5)<10);
% B = A(I,:);
% disp(B)
%できる

%%five 行列の特定の行を繰り返し削除する
% A=[1,1;2,2;3,3;4,4;5,5;6,6;7,7;8,8;9,9];
% i = 1;
% while i < 9
%     if rem(A(i,1),3) == 0
%     A(i,:) = [];
%     end
%     i = i + 1;
% end
%結論：このコードだと削除するごとに行列の値が変化するためindexエラーが起きてしまう

%%複数行列の下に複数行列を連結できるか
% A = zeros(3,3);
% B = zeros(3,3);
% C = [A;B];
% disp(C)
%結論:できる
